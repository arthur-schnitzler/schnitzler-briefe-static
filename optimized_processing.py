#!/usr/bin/env python3
"""
Memory-optimized processing utilities for large TEI datasets
Provides streaming and batching capabilities for better performance
"""

import os
import gc
import json
import logging
from typing import Iterator, Dict, Any, Optional, List
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor
import multiprocessing as mp
from functools import lru_cache
from dataclasses import dataclass
import psutil

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class ProcessingStats:
    """Statistics for processing performance"""
    files_processed: int = 0
    memory_usage_mb: float = 0.0
    processing_time: float = 0.0
    errors: List[str] = None
    
    def __post_init__(self):
        if self.errors is None:
            self.errors = []

class MemoryOptimizedProcessor:
    """Base class for memory-optimized TEI processing"""
    
    def __init__(self, batch_size: int = 100, max_workers: int = None):
        self.batch_size = batch_size
        self.max_workers = max_workers or min(4, mp.cpu_count())
        self.stats = ProcessingStats()
        
    def get_memory_usage(self) -> float:
        """Get current memory usage in MB"""
        process = psutil.Process(os.getpid())
        return process.memory_info().rss / 1024 / 1024
    
    def batch_files(self, file_paths: List[str]) -> Iterator[List[str]]:
        """Yield batches of file paths for processing"""
        for i in range(0, len(file_paths), self.batch_size):
            yield file_paths[i:i + self.batch_size]
    
    @lru_cache(maxsize=1000)
    def cached_entity_lookup(self, entity_id: str, entity_type: str) -> Optional[Dict[str, Any]]:
        """Cached entity lookup to avoid repeated file reads"""
        # Implementation would depend on your entity storage
        return None
    
    def process_file_safe(self, file_path: str) -> Optional[Dict[str, Any]]:
        """Process a single file with error handling"""
        try:
            from acdh_tei_pyutils.tei import TeiReader
            
            doc = TeiReader(file_path)
            
            # Extract basic information
            result = {
                'file_path': file_path,
                'id': os.path.splitext(os.path.basename(file_path))[0],
                'title': None,
                'date': None,
                'entities': {'persons': [], 'places': [], 'orgs': [], 'works': []}
            }
            
            # Title extraction with fallback
            try:
                result['title'] = doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')[0]
            except (IndexError, AttributeError):
                result['title'] = result['id']
            
            # Date extraction with fallback
            try:
                result['date'] = doc.any_xpath('.//tei:titleStmt/tei:title[@type="iso-date"]/@when-iso')[0]
            except (IndexError, AttributeError):
                pass
            
            # Extract entities efficiently
            for entity_type, xpath in [
                ('persons', './/tei:back//tei:person[@xml:id]'),
                ('places', './/tei:back//tei:place[@xml:id]'),
                ('orgs', './/tei:back//tei:org[@xml:id]'),
                ('works', './/tei:back//tei:bibl[@xml:id]')
            ]:
                try:
                    entities = doc.any_xpath(xpath)
                    for entity in entities:
                        entity_id = entity.get('{http://www.w3.org/XML/1998/namespace}id')
                        if entity_id:
                            result['entities'][entity_type].append({
                                'id': entity_id,
                                'name': self._extract_entity_name(entity, entity_type)
                            })
                except Exception as e:
                    logger.warning(f"Error extracting {entity_type} from {file_path}: {e}")
            
            return result
            
        except Exception as e:
            logger.error(f"Error processing {file_path}: {e}")
            self.stats.errors.append(f"{file_path}: {str(e)}")
            return None
        finally:
            # Force garbage collection for large files
            gc.collect()
    
    def _extract_entity_name(self, entity, entity_type: str) -> str:
        """Extract entity name based on type"""
        try:
            if entity_type == 'persons':
                forename = entity.xpath('.//tei:forename/text()')
                surname = entity.xpath('.//tei:surname/text()')
                if forename and surname:
                    return f"{forename[0]} {surname[0]}"
                elif surname:
                    return surname[0]
                elif forename:
                    return forename[0]
            elif entity_type == 'places':
                placename = entity.xpath('.//tei:placeName[1]/text()')
                if placename:
                    return placename[0]
            elif entity_type == 'orgs':
                orgname = entity.xpath('.//tei:orgName[1]/text()')
                if orgname:
                    return orgname[0]
            elif entity_type == 'works':
                title = entity.xpath('.//tei:title[1]/text()')
                if title:
                    return title[0]
        except Exception:
            pass
        return "Unknown"
    
    def process_batch_parallel(self, file_batch: List[str]) -> List[Dict[str, Any]]:
        """Process a batch of files in parallel"""
        results = []
        
        with ThreadPoolExecutor(max_workers=min(len(file_batch), 4)) as executor:
            future_to_file = {
                executor.submit(self.process_file_safe, file_path): file_path 
                for file_path in file_batch
            }
            
            for future in future_to_file:
                result = future.result()
                if result:
                    results.append(result)
                
                self.stats.files_processed += 1
                if self.stats.files_processed % 50 == 0:
                    current_memory = self.get_memory_usage()
                    logger.info(f"Processed {self.stats.files_processed} files, Memory: {current_memory:.1f}MB")
        
        return results
    
    def process_files_streaming(self, file_paths: List[str]) -> Iterator[Dict[str, Any]]:
        """Process files in streaming fashion to minimize memory usage"""
        logger.info(f"Processing {len(file_paths)} files in batches of {self.batch_size}")
        
        for batch in self.batch_files(file_paths):
            batch_results = self.process_batch_parallel(batch)
            
            for result in batch_results:
                yield result
            
            # Memory cleanup after each batch
            gc.collect()
            
            # Log memory usage
            current_memory = self.get_memory_usage()
            self.stats.memory_usage_mb = max(self.stats.memory_usage_mb, current_memory)

class IncrementalBuilder:
    """Incremental build system to avoid reprocessing unchanged files"""
    
    def __init__(self, cache_dir: str = "./build-cache"):
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(exist_ok=True)
        self.cache_file = self.cache_dir / "file_hashes.json"
        self.load_cache()
    
    def load_cache(self):
        """Load file hash cache"""
        try:
            if self.cache_file.exists():
                with open(self.cache_file, 'r') as f:
                    self.file_hashes = json.load(f)
            else:
                self.file_hashes = {}
        except Exception as e:
            logger.warning(f"Could not load cache: {e}")
            self.file_hashes = {}
    
    def save_cache(self):
        """Save file hash cache"""
        try:
            with open(self.cache_file, 'w') as f:
                json.dump(self.file_hashes, f, indent=2)
        except Exception as e:
            logger.error(f"Could not save cache: {e}")
    
    def get_file_hash(self, file_path: str) -> str:
        """Get file hash for change detection"""
        import hashlib
        
        try:
            with open(file_path, 'rb') as f:
                return hashlib.md5(f.read()).hexdigest()
        except Exception:
            return ""
    
    def get_changed_files(self, file_paths: List[str]) -> List[str]:
        """Get list of files that have changed since last build"""
        changed_files = []
        
        for file_path in file_paths:
            current_hash = self.get_file_hash(file_path)
            cached_hash = self.file_hashes.get(file_path)
            
            if current_hash != cached_hash:
                changed_files.append(file_path)
                self.file_hashes[file_path] = current_hash
        
        logger.info(f"Found {len(changed_files)} changed files out of {len(file_paths)} total")
        return changed_files
    
    def mark_processed(self, file_paths: List[str]):
        """Mark files as processed and save cache"""
        for file_path in file_paths:
            self.file_hashes[file_path] = self.get_file_hash(file_path)
        
        self.save_cache()

class ProgressiveProcessor:
    """Progressive processing with checkpoints and resume capability"""
    
    def __init__(self, checkpoint_dir: str = "./checkpoints"):
        self.checkpoint_dir = Path(checkpoint_dir)
        self.checkpoint_dir.mkdir(exist_ok=True)
    
    def save_checkpoint(self, stage: str, data: Dict[str, Any]):
        """Save processing checkpoint"""
        checkpoint_file = self.checkpoint_dir / f"{stage}_checkpoint.json"
        try:
            with open(checkpoint_file, 'w') as f:
                json.dump(data, f, indent=2, default=str)
            logger.info(f"Checkpoint saved: {stage}")
        except Exception as e:
            logger.error(f"Could not save checkpoint {stage}: {e}")
    
    def load_checkpoint(self, stage: str) -> Optional[Dict[str, Any]]:
        """Load processing checkpoint"""
        checkpoint_file = self.checkpoint_dir / f"{stage}_checkpoint.json"
        try:
            if checkpoint_file.exists():
                with open(checkpoint_file, 'r') as f:
                    data = json.load(f)
                logger.info(f"Checkpoint loaded: {stage}")
                return data
        except Exception as e:
            logger.error(f"Could not load checkpoint {stage}: {e}")
        return None
    
    def clear_checkpoints(self):
        """Clear all checkpoints"""
        for checkpoint_file in self.checkpoint_dir.glob("*_checkpoint.json"):
            try:
                checkpoint_file.unlink()
            except Exception as e:
                logger.error(f"Could not remove checkpoint {checkpoint_file}: {e}")

# Usage examples and utilities
def optimize_calendar_data_generation():
    """Optimized version of make_calendar_data.py"""
    import glob
    from acdh_tei_pyutils.tei import TeiReader
    
    processor = MemoryOptimizedProcessor(batch_size=50)
    builder = IncrementalBuilder()
    
    files = sorted(glob.glob("./data/editions/*.xml"))
    changed_files = builder.get_changed_files(files)
    
    if not changed_files:
        logger.info("No files changed, skipping calendar data generation")
        return
    
    data = []
    for result in processor.process_files_streaming(changed_files):
        if result and result.get('date'):
            calendar_item = {
                "name": result['title'],
                "startDate": result['date'],
                "id": f"{result['id']}.html",
                "tageszaehler": result.get('tageszaehler', '01')
            }
            data.append(calendar_item)
    
    # Save results
    out_path = os.path.join("html", "js-data")
    os.makedirs(out_path, exist_ok=True)
    out_file = os.path.join(out_path, "calendarData.js")
    
    with open(out_file, "w", encoding="utf8") as f:
        my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)}"
        f.write(my_js_variable)
    
    builder.mark_processed(changed_files)
    logger.info(f"Calendar data generated with {len(data)} items")

if __name__ == "__main__":
    # Example usage
    optimize_calendar_data_generation()
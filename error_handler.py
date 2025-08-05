#!/usr/bin/env python3
"""
Comprehensive error handling and logging system for the Schnitzler Briefe build process
Provides structured logging, error recovery, and build validation
"""

import os
import sys
import json
import logging
import traceback
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional, Callable
from functools import wraps
from contextlib import contextmanager
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Configure structured logging
class StructuredFormatter(logging.Formatter):
    """Custom formatter for structured logging"""
    
    def format(self, record):
        log_data = {
            'timestamp': datetime.utcnow().isoformat(),
            'level': record.levelname,
            'logger': record.name,
            'message': record.getMessage(),
            'module': record.module,
            'function': record.funcName,
            'line': record.lineno
        }
        
        # Add exception info if present
        if record.exc_info:
            log_data['exception'] = {
                'type': record.exc_info[0].__name__,
                'message': str(record.exc_info[1]),
                'traceback': traceback.format_exception(*record.exc_info)
            }
        
        # Add extra fields
        for key, value in record.__dict__.items():
            if key not in ['name', 'msg', 'args', 'levelname', 'levelno', 'pathname', 
                          'filename', 'module', 'exc_info', 'exc_text', 'stack_info',
                          'lineno', 'funcName', 'created', 'msecs', 'relativeCreated',
                          'thread', 'threadName', 'processName', 'process', 'message']:
                log_data['extra'] = log_data.get('extra', {})
                log_data['extra'][key] = value
        
        return json.dumps(log_data)

class BuildLogger:
    """Enhanced logging system for build processes"""
    
    def __init__(self, log_dir: str = "./logs", log_level: str = "INFO"):
        self.log_dir = Path(log_dir)
        self.log_dir.mkdir(exist_ok=True)
        
        # Create different loggers for different components
        self.loggers = {}
        self.setup_loggers(log_level)
        
        # Error collection
        self.errors = []
        self.warnings = []
        self.build_stats = {
            'start_time': datetime.now(),
            'end_time': None,
            'files_processed': 0,
            'errors': 0,
            'warnings': 0,
            'success': False
        }
    
    def setup_loggers(self, log_level: str):
        """Setup different loggers for different components"""
        
        components = ['xslt', 'python', 'javascript', 'build', 'validation']
        
        for component in components:
            logger = logging.getLogger(f'schnitzler.{component}')
            logger.setLevel(getattr(logging, log_level))
            
            # File handler with structured logging
            file_handler = logging.FileHandler(
                self.log_dir / f'{component}.log',
                encoding='utf-8'
            )
            file_handler.setFormatter(StructuredFormatter())
            
            # Console handler for immediate feedback
            console_handler = logging.StreamHandler()
            console_handler.setFormatter(logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
            ))
            
            logger.addHandler(file_handler)
            logger.addHandler(console_handler)
            
            self.loggers[component] = logger
    
    def get_logger(self, component: str) -> logging.Logger:
        """Get logger for specific component"""
        return self.loggers.get(component, self.loggers['build'])
    
    def log_error(self, component: str, message: str, exception: Exception = None, **kwargs):
        """Log error with additional context"""
        logger = self.get_logger(component)
        
        error_data = {
            'component': component,
            'message': message,
            'timestamp': datetime.now().isoformat(),
            **kwargs
        }
        
        if exception:
            error_data['exception_type'] = type(exception).__name__
            error_data['exception_message'] = str(exception)
        
        self.errors.append(error_data)
        self.build_stats['errors'] += 1
        
        logger.error(message, exc_info=exception, extra=kwargs)
    
    def log_warning(self, component: str, message: str, **kwargs):
        """Log warning with additional context"""
        logger = self.get_logger(component)
        
        warning_data = {
            'component': component,
            'message': message,
            'timestamp': datetime.now().isoformat(),
            **kwargs
        }
        
        self.warnings.append(warning_data)
        self.build_stats['warnings'] += 1
        
        logger.warning(message, extra=kwargs)
    
    def log_progress(self, component: str, processed: int, total: int, message: str = ""):
        """Log progress information"""
        logger = self.get_logger(component)
        
        progress_percent = (processed / total * 100) if total > 0 else 0
        
        logger.info(f"Progress: {processed}/{total} ({progress_percent:.1f}%) {message}",
                   extra={'processed': processed, 'total': total, 'percent': progress_percent})
    
    def finalize_build(self, success: bool = True):
        """Finalize build logging and generate reports"""
        self.build_stats['end_time'] = datetime.now()
        self.build_stats['success'] = success and len(self.errors) == 0
        self.build_stats['duration'] = (
            self.build_stats['end_time'] - self.build_stats['start_time']
        ).total_seconds()
        
        # Generate summary report
        self.generate_build_report()
        
        # Send notifications if needed
        if self.errors or (self.warnings and len(self.warnings) > 10):
            self.send_notification()
    
    def generate_build_report(self):
        """Generate comprehensive build report"""
        report = {
            'build_stats': self.build_stats,
            'errors': self.errors,
            'warnings': self.warnings,
            'summary': {
                'total_errors': len(self.errors),
                'total_warnings': len(self.warnings),
                'success_rate': (
                    (self.build_stats['files_processed'] - len(self.errors)) / 
                    max(self.build_stats['files_processed'], 1) * 100
                )
            }
        }
        
        # Save report
        report_path = self.log_dir / f"build_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, default=str)
        
        print(f"\n{'='*50}")
        print("BUILD REPORT")
        print(f"{'='*50}")
        print(f"Duration: {self.build_stats['duration']:.2f} seconds")
        print(f"Files processed: {self.build_stats['files_processed']}")
        print(f"Errors: {len(self.errors)}")
        print(f"Warnings: {len(self.warnings)}")
        print(f"Success: {'✓' if self.build_stats['success'] else '✗'}")
        print(f"Report saved: {report_path}")
        print(f"{'='*50}")
    
    def send_notification(self):
        """Send notification about build issues (email, webhook, etc.)"""
        # This would implement actual notification logic
        # For now, just log the notification intent
        logger = self.get_logger('build')
        logger.info("Build notification would be sent",
                   extra={'errors': len(self.errors), 'warnings': len(self.warnings)})

# Decorator for robust error handling
def handle_errors(component: str, logger_instance: BuildLogger = None, 
                 retry_count: int = 0, fallback: Callable = None):
    """Decorator for robust error handling with retry logic"""
    
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            last_exception = None
            
            for attempt in range(retry_count + 1):
                try:
                    result = func(*args, **kwargs)
                    
                    if logger_instance and attempt > 0:
                        logger_instance.get_logger(component).info(
                            f"Function {func.__name__} succeeded on attempt {attempt + 1}"
                        )
                    
                    return result
                    
                except Exception as e:
                    last_exception = e
                    
                    if logger_instance:
                        logger_instance.log_error(
                            component, 
                            f"Function {func.__name__} failed on attempt {attempt + 1}: {str(e)}",
                            exception=e,
                            function_name=func.__name__,
                            attempt=attempt + 1
                        )
                    
                    if attempt < retry_count:
                        import time
                        time.sleep(2 ** attempt)  # Exponential backoff
                    
            # All retries failed
            if fallback:
                try:
                    result = fallback(*args, **kwargs)
                    if logger_instance:
                        logger_instance.get_logger(component).warning(
                            f"Function {func.__name__} failed, using fallback"
                        )
                    return result
                except Exception as fallback_error:
                    if logger_instance:
                        logger_instance.log_error(
                            component,
                            f"Fallback for {func.__name__} also failed: {str(fallback_error)}",
                            exception=fallback_error
                        )
            
            # Re-raise the last exception
            raise last_exception
        
        return wrapper
    return decorator

# Context manager for file operations
@contextmanager
def safe_file_operation(file_path: str, operation: str, logger_instance: BuildLogger = None):
    """Context manager for safe file operations with proper error handling"""
    
    try:
        yield file_path
    except FileNotFoundError as e:
        if logger_instance:
            logger_instance.log_error(
                'filesystem',
                f"File not found during {operation}: {file_path}",
                exception=e,
                file_path=file_path,
                operation=operation
            )
        raise
    except PermissionError as e:
        if logger_instance:
            logger_instance.log_error(
                'filesystem',
                f"Permission denied during {operation}: {file_path}",
                exception=e,
                file_path=file_path,
                operation=operation
            )
        raise
    except Exception as e:
        if logger_instance:
            logger_instance.log_error(
                'filesystem',
                f"Unexpected error during {operation}: {file_path}",
                exception=e,
                file_path=file_path,
                operation=operation
            )
        raise

class ValidationError(Exception):
    """Custom exception for validation errors"""
    
    def __init__(self, message: str, validation_type: str, details: Dict[str, Any] = None):
        super().__init__(message)
        self.validation_type = validation_type
        self.details = details or {}

class BuildValidator:
    """Validator for build output and data integrity"""
    
    def __init__(self, logger_instance: BuildLogger):
        self.logger = logger_instance
        self.validation_rules = []
    
    def add_rule(self, rule_name: str, validator_func: Callable, critical: bool = True):
        """Add validation rule"""
        self.validation_rules.append({
            'name': rule_name,
            'func': validator_func,
            'critical': critical
        })
    
    def validate_all(self) -> bool:
        """Run all validation rules"""
        all_passed = True
        
        for rule in self.validation_rules:
            try:
                result = rule['func']()
                
                if not result:
                    message = f"Validation rule '{rule['name']}' failed"
                    
                    if rule['critical']:
                        self.logger.log_error('validation', message, 
                                           rule_name=rule['name'], critical=True)
                        all_passed = False
                    else:
                        self.logger.log_warning('validation', message,
                                             rule_name=rule['name'])
                
            except Exception as e:
                self.logger.log_error('validation', 
                                   f"Validation rule '{rule['name']}' threw exception: {str(e)}",
                                   exception=e, rule_name=rule['name'])
                if rule['critical']:
                    all_passed = False
        
        return all_passed

# Example usage and integration
if __name__ == "__main__":
    # Initialize logging system
    build_logger = BuildLogger(log_level="DEBUG")
    
    # Example of decorated function
    @handle_errors('python', build_logger, retry_count=2)
    def process_file(file_path: str):
        with safe_file_operation(file_path, 'read', build_logger):
            # Simulate processing
            if 'error' in file_path:
                raise ValueError("Simulated error")
            return f"Processed {file_path}"
    
    # Example usage
    try:
        result = process_file("test_file.xml")
        print(result)
    except Exception as e:
        print(f"Final error: {e}")
    
    # Finalize build
    build_logger.finalize_build(success=True)
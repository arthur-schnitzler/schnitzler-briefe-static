import glob
import os
import xml.etree.ElementTree as ET
from datetime import datetime
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

def generate_sitemap():
    """Generate a comprehensive sitemap.xml for the Schnitzler Briefe website"""
    
    # Base URL of the website
    base_url = "https://schnitzler-briefe.acdh.oeaw.ac.at"
    
    # Create the root element
    urlset = ET.Element("urlset")
    urlset.set("xmlns", "http://www.sitemaps.org/schemas/sitemap/0.9")
    urlset.set("xmlns:xhtml", "http://www.w3.org/1999/xhtml")
    
    # Static pages with their priorities and change frequencies
    static_pages = [
        {"url": "", "priority": "1.0", "changefreq": "monthly"},  # Homepage
        {"url": "about.html", "priority": "0.8", "changefreq": "monthly"},
        {"url": "calendar.html", "priority": "0.9", "changefreq": "weekly"},
        {"url": "search.html", "priority": "0.8", "changefreq": "monthly"},
        {"url": "toc.html", "priority": "0.9", "changefreq": "weekly"},
        {"url": "tocs.html", "priority": "0.8", "changefreq": "monthly"},
        {"url": "tocs-female-writers.html", "priority": "0.7", "changefreq": "monthly"},
        {"url": "correspaction.html", "priority": "0.7", "changefreq": "monthly"},
        {"url": "archives.html", "priority": "0.6", "changefreq": "monthly"},
        {"url": "listperson.html", "priority": "0.8", "changefreq": "weekly"},
        {"url": "listbibl.html", "priority": "0.7", "changefreq": "monthly"},
        {"url": "listplace.html", "priority": "0.7", "changefreq": "monthly"},
        {"url": "listorg.html", "priority": "0.7", "changefreq": "monthly"},
        {"url": "listevent.html", "priority": "0.7", "changefreq": "monthly"},
        {"url": "status.html", "priority": "0.6", "changefreq": "monthly"},
        {"url": "editionsrichtlinien.html", "priority": "0.5", "changefreq": "yearly"},
        {"url": "ansichten.html", "priority": "0.5", "changefreq": "yearly"},
        {"url": "statistiken.html", "priority": "0.6", "changefreq": "monthly"},
        {"url": "danksagung.html", "priority": "0.4", "changefreq": "yearly"},
        {"url": "kooperationen.html", "priority": "0.4", "changefreq": "yearly"},
        {"url": "epub.html", "priority": "0.6", "changefreq": "monthly"},
        {"url": "drucke.html", "priority": "0.5", "changefreq": "yearly"},
        {"url": "gedruckte-korrespondenz.html", "priority": "0.5", "changefreq": "yearly"},
        {"url": "elemente.html", "priority": "0.4", "changefreq": "yearly"},
        {"url": "arbeitsablauf.html", "priority": "0.4", "changefreq": "yearly"},
        {"url": "quelldatenUndAPI.html", "priority": "0.5", "changefreq": "monthly"},
    ]
    
    # Add static pages
    for page in static_pages:
        url_elem = ET.SubElement(urlset, "url")
        
        loc_elem = ET.SubElement(url_elem, "loc")
        loc_elem.text = f"{base_url}/{page['url']}"
        
        lastmod_elem = ET.SubElement(url_elem, "lastmod")
        lastmod_elem.text = datetime.now().strftime("%Y-%m-%d")
        
        changefreq_elem = ET.SubElement(url_elem, "changefreq")
        changefreq_elem.text = page["changefreq"]
        
        priority_elem = ET.SubElement(url_elem, "priority")
        priority_elem.text = page["priority"]
    
    # Get all letter/edition files
    files = sorted(glob.glob("./data/editions/*.xml"))
    
    print(f"Processing {len(files)} edition files for sitemap...")
    
    for file_path in tqdm(files, desc="Processing editions"):
        try:
            doc = TeiReader(file_path)
            filename = os.path.basename(file_path).replace(".xml", ".html")
            
            # Get the document date for lastmod
            try:
                doc_date = doc.any_xpath('//tei:titleStmt/tei:title[@type="iso-date"]/@when-iso')[0]
                # Convert to proper date format
                if len(doc_date) >= 10:
                    lastmod_date = doc_date[:10]  # YYYY-MM-DD
                else:
                    lastmod_date = datetime.now().strftime("%Y-%m-%d")
            except (IndexError, ValueError):
                lastmod_date = datetime.now().strftime("%Y-%m-%d")
            
            # Create URL entry for the letter
            url_elem = ET.SubElement(urlset, "url")
            
            loc_elem = ET.SubElement(url_elem, "loc")
            loc_elem.text = f"{base_url}/{filename}"
            
            lastmod_elem = ET.SubElement(url_elem, "lastmod")
            lastmod_elem.text = lastmod_date
            
            changefreq_elem = ET.SubElement(url_elem, "changefreq")
            changefreq_elem.text = "monthly"
            
            priority_elem = ET.SubElement(url_elem, "priority")
            priority_elem.text = "0.7"
            
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            continue
    
    # Get all index files (person, place, org, etc.)
    index_patterns = [
        "./data/indices/listperson.xml",
        "./data/indices/listplace.xml", 
        "./data/indices/listorg.xml",
        "./data/indices/listbibl.xml"
    ]
    
    for pattern in index_patterns:
        index_files = glob.glob(pattern)
        for file_path in index_files:
            try:
                doc = TeiReader(file_path)
                
                # Get all entities with xml:id
                entities = doc.any_xpath(".//*[@xml:id]")
                
                for entity in entities:
                    entity_id = entity.get("{http://www.w3.org/XML/1998/namespace}id")
                    if entity_id:
                        url_elem = ET.SubElement(urlset, "url")
                        
                        loc_elem = ET.SubElement(url_elem, "loc")
                        loc_elem.text = f"{base_url}/{entity_id}.html"
                        
                        lastmod_elem = ET.SubElement(url_elem, "lastmod")
                        lastmod_elem.text = datetime.now().strftime("%Y-%m-%d")
                        
                        changefreq_elem = ET.SubElement(url_elem, "changefreq")
                        changefreq_elem.text = "monthly"
                        
                        priority_elem = ET.SubElement(url_elem, "priority")
                        priority_elem.text = "0.6"
                        
            except Exception as e:
                print(f"Error processing index file {file_path}: {e}")
                continue
    
    # Create the XML tree and write to file
    tree = ET.ElementTree(urlset)
    ET.indent(tree, space="  ", level=0)
    
    sitemap_path = "./html/sitemap.xml"
    tree.write(sitemap_path, encoding="utf-8", xml_declaration=True)
    
    print(f"Sitemap generated successfully: {sitemap_path}")
    print(f"Total URLs in sitemap: {len(urlset)}")
    
    return sitemap_path

def generate_robots_txt():
    """Generate robots.txt file for SEO"""
    
    robots_content = """User-agent: *

# Sitemap
Sitemap: https://schnitzler-briefe.acdh.oeaw.ac.at/sitemap.xml

# Crawl-delay for politeness
Crawl-delay: 1

# Disallow certain directories
Disallow: /data/
Disallow: /xslt/
Disallow: /js-data/

# Allow HTML pages and sitemap
Allow: /*.html
Allow: /sitemap.xml

# Block other XML/XSL files
Disallow: /*.xml
Disallow: /*.xsl

# Allow important static resources
Allow: /css/
Allow: /js/
Allow: /img/

# Allow everything else
Allow: /
"""
    
    robots_path = "./html/robots.txt"
    with open(robots_path, 'w', encoding='utf-8') as f:
        f.write(robots_content)
    
    print(f"Robots.txt generated: {robots_path}")
    return robots_path

if __name__ == "__main__":
    print("Generating SEO files...")
    generate_sitemap()
    generate_robots_txt()
    print("SEO file generation completed!")
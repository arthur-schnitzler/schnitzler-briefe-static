import glob
import os
import json
from collections import defaultdict, Counter
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

def generate_seo_statistics():
    """Generate SEO statistics and metadata for analysis"""
    
    files = sorted(glob.glob("./data/editions/*.xml"))
    
    stats = {
        "total_letters": len(files),
        "date_range": {"earliest": None, "latest": None},
        "correspondents": Counter(),
        "places": Counter(),
        "years": Counter(),
        "letter_types": Counter(),
        "languages": Counter({"de": len(files)}),  # Assume all German
        "keywords_frequency": Counter(),
        "topics": Counter()
    }
    
    print(f"Analyzing {len(files)} letters for SEO metadata...")
    
    for file_path in tqdm(files, desc="Processing letters"):
        try:
            doc = TeiReader(file_path)
            
            # Extract date information
            try:
                date_str = doc.any_xpath('//tei:title[@type="iso-date"]/@when-iso')[0]
                if stats["date_range"]["earliest"] is None or date_str < stats["date_range"]["earliest"]:
                    stats["date_range"]["earliest"] = date_str
                if stats["date_range"]["latest"] is None or date_str > stats["date_range"]["latest"]:
                    stats["date_range"]["latest"] = date_str
                
                year = date_str[:4]
                stats["years"][year] += 1
                
            except IndexError:
                pass
            
            # Extract correspondents
            try:
                sender = doc.any_xpath('//tei:correspAction[@type="sent"]//tei:persName/text()')[0]
                stats["correspondents"][sender] += 1
                
                # Determine letter type based on Schnitzler involvement
                if "Schnitzler" in sender:
                    stats["letter_types"]["from_schnitzler"] += 1
                else:
                    stats["letter_types"]["to_schnitzler"] += 1
                    
            except IndexError:
                pass
            
            try:
                receiver = doc.any_xpath('//tei:correspAction[@type="received"]//tei:persName/text()')[0]
                stats["correspondents"][receiver] += 1
            except IndexError:
                pass
            
            # Extract places
            for place in doc.any_xpath('.//tei:back//tei:place'):
                try:
                    place_name = place.xpath('.//tei:placeName[1]/text()')[0]
                    stats["places"][place_name] += 1
                except IndexError:
                    pass
            
            # Extract persons for keyword generation
            for person in doc.any_xpath('.//tei:back//tei:person'):
                try:
                    person_name = person.xpath('.//tei:persName/tei:surname/text()')[0]
                    stats["keywords_frequency"][person_name] += 1
                except IndexError:
                    pass
            
            # Extract works/literature
            for work in doc.any_xpath('.//tei:back//tei:bibl'):
                try:
                    work_title = work.xpath('.//tei:title[1]/text()')[0]
                    if len(work_title) > 5:  # Filter short titles
                        stats["topics"][work_title] += 1
                except IndexError:
                    pass
                    
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            continue
    
    # Generate popular keywords list
    popular_keywords = [
        "Arthur Schnitzler", "Briefwechsel", "Korrespondenz", "Wien", 
        "Literatur", "Fin de Siècle", "Jung Wien", "digitale Edition"
    ]
    
    # Add most frequent correspondents (excluding Schnitzler)
    for correspondent, count in stats["correspondents"].most_common(20):
        if "Schnitzler" not in correspondent and count > 5:
            popular_keywords.append(correspondent)
    
    # Add most frequent places
    for place, count in stats["places"].most_common(10):
        if count > 10:
            popular_keywords.append(place)
    
    stats["popular_keywords"] = popular_keywords
    
    # Generate SEO-friendly content suggestions
    stats["seo_suggestions"] = {
        "main_description": f"Digitale Edition der Korrespondenz Arthur Schnitzlers mit über {stats['total_letters']} Briefen aus den Jahren {stats['date_range']['earliest'][:4]} bis {stats['date_range']['latest'][:4]}. Vollständig durchsuchbare Sammlung mit Faksimiles und wissenschaftlichem Kommentar.",
        "keywords_meta": ", ".join(popular_keywords[:20]),
        "topics_for_content": list(stats["topics"].most_common(10)),
        "geographical_focus": list(stats["places"].most_common(10)),
        "temporal_coverage": f"{stats['date_range']['earliest'][:4]}-{stats['date_range']['latest'][:4]}"
    }
    
    return stats

def generate_breadcrumb_data():
    """Generate breadcrumb navigation data for better SEO"""
    
    breadcrumb_templates = {
        "letter": {
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://schnitzler-briefe.acdh.oeaw.ac.at/"
                },
                {
                    "@type": "ListItem", 
                    "position": 2,
                    "name": "Briefe",
                    "item": "https://schnitzler-briefe.acdh.oeaw.ac.at/toc.html"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "{letter_title}",
                    "item": "https://schnitzler-briefe.acdh.oeaw.ac.at/{letter_id}.html"
                }
            ]
        },
        "person": {
            "@context": "https://schema.org",
            "@type": "BreadcrumbList", 
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://schnitzler-briefe.acdh.oeaw.ac.at/"
                },
                {
                    "@type": "ListItem",
                    "position": 2, 
                    "name": "Personen",
                    "item": "https://schnitzler-briefe.acdh.oeaw.ac.at/listperson.html"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "{person_name}",
                    "item": "https://schnitzler-briefe.acdh.oeaw.ac.at/{person_id}.html"
                }
            ]
        }
    }
    
    return breadcrumb_templates

def save_seo_data():
    """Save SEO data to JSON files for use in build process"""
    
    print("Generating SEO statistics...")
    stats = generate_seo_statistics()
    
    print("Generating breadcrumb templates...")
    breadcrumbs = generate_breadcrumb_data()
    
    # Create output directory
    os.makedirs("./html/seo-data", exist_ok=True)
    
    # Save statistics
    with open("./html/seo-data/seo-statistics.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, ensure_ascii=False, indent=2)
    
    # Save breadcrumb templates
    with open("./html/seo-data/breadcrumb-templates.json", "w", encoding="utf-8") as f:
        json.dump(breadcrumbs, f, ensure_ascii=False, indent=2)
    
    # Generate a summary report
    report = f"""# SEO Analysis Report

## Website Statistics
- Total Letters: {stats['total_letters']}
- Date Range: {stats['date_range']['earliest']} to {stats['date_range']['latest']}
- Most Active Year: {stats['years'].most_common(1)[0][0]} ({stats['years'].most_common(1)[0][1]} letters)
- Letters from Schnitzler: {stats['letter_types'].get('from_schnitzler', 0)}
- Letters to Schnitzler: {stats['letter_types'].get('to_schnitzler', 0)}

## Top Correspondents
{chr(10).join([f"- {name}: {count} letters" for name, count in stats['correspondents'].most_common(10)])}

## Top Places  
{chr(10).join([f"- {place}: {count} mentions" for place, count in stats['places'].most_common(10)])}

## SEO Recommendations
- Main Description: {stats['seo_suggestions']['main_description']}
- Recommended Keywords: {stats['seo_suggestions']['keywords_meta'][:200]}...
- Temporal Coverage: {stats['seo_suggestions']['temporal_coverage']}

## Popular Topics
{chr(10).join([f"- {topic}: {count} mentions" for topic, count in stats['topics'].most_common(10)])}
"""
    
    with open("./html/seo-data/seo-report.md", "w", encoding="utf-8") as f:
        f.write(report)
    
    print(f"SEO data saved to ./html/seo-data/")
    print(f"Total letters analyzed: {stats['total_letters']}")
    print(f"Date range: {stats['date_range']['earliest']} - {stats['date_range']['latest']}")
    print(f"Top correspondent: {stats['correspondents'].most_common(1)[0][0]} ({stats['correspondents'].most_common(1)[0][1]} letters)")
    
    return stats

if __name__ == "__main__":
    save_seo_data()
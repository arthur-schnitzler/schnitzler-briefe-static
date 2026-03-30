#!/usr/bin/env python3
"""
Script to fetch and integrate CMIF printed letters data into calendar
"""

import requests
import xml.etree.ElementTree as ET
import json
import re
from datetime import datetime

CMIF_SOURCES = [
    {
        'url': 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-data/refs/heads/main/import-lists/schnitzler-cmif_tage.xml',
        'category': 'gedruckt',
        'label': 'gedruckte Briefe',
    },
    {
        'url': 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-data/refs/heads/main/import-lists/schnitzler-fischer-cmif_tage.xml',
        'category': 'fischer',
        'label': 'S. Fischer',
    },
]

def fetch_cmif_data(url):
    """Fetch CMIF data from GitHub"""
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"Error fetching CMIF data: {e}")
        return None

def parse_cmif_xml(xml_content, category):
    """Parse CMIF XML and extract letter events"""
    try:
        root = ET.fromstring(xml_content)
        events = []

        # Define namespace
        namespace = {'tei': 'http://www.tei-c.org/ns/1.0'}

        # Find all event elements with namespace
        for event in root.findall('.//tei:event', namespace):
            when_iso = event.get('when-iso')
            if not when_iso:
                continue

            # Extract head text for letter description
            head = event.find('tei:head', namespace)
            if head is not None and head.text:
                letter_title = head.text.strip()

                # Extract bibliographic information
                bibl = event.find('.//tei:bibl', namespace)
                bibliographic_info = bibl.text.strip() if bibl is not None and bibl.text else "Bibliographische Angabe nicht verfügbar"

                # Extract external link URL (for fischer: idno[@type="schnitzler-fischer"])
                idno = event.find('.//tei:idno[@type="schnitzler-fischer"]', namespace)
                link_url = idno.text.strip() if idno is not None and idno.text else None

                # Generate a unique ID
                date_part = when_iso.replace('-', '')
                title_part = re.sub(r'[^a-zA-Z0-9]', '', letter_title)[:20]
                letter_id = f"CMIF_{category}_{date_part}_{title_part}"

                calendar_event = {
                    'startDate': when_iso,
                    'name': letter_title,
                    'id': letter_id,
                    'category': category,
                    'tageszaehler': 0,
                    'bibliographic': bibliographic_info,
                    'link_url': link_url
                }

                events.append(calendar_event)

        return events

    except ET.ParseError as e:
        print(f"Error parsing XML: {e}")
        return []

def integrate_cmif_data():
    """Main function to integrate CMIF data from all sources"""
    import os
    calendar_file = 'html/js-data/calendarData.js'
    if not os.path.exists(calendar_file):
        print(f"Calendar data file {calendar_file} not found!")
        return False

    # Load existing calendar data
    try:
        with open(calendar_file, 'r', encoding='utf-8') as f:
            content = f.read()
        json_start = content.find('[')
        json_end = content.rfind(']') + 1
        if json_start == -1 or json_end <= json_start:
            print("Could not find JSON array in calendar data file")
            return False
        existing_data = json.loads(content[json_start:json_end])
        print(f"Loaded {len(existing_data)} existing calendar entries")
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading existing calendar data: {e}")
        existing_data = []

    # Collect all CMIF categories to remove before re-adding
    cmif_categories = {s['category'] for s in CMIF_SOURCES}
    base_data = [e for e in existing_data if e.get('category') not in cmif_categories]
    print(f"Base entries (without CMIF): {len(base_data)}")

    all_new_events = []
    for source in CMIF_SOURCES:
        print(f"Fetching {source['label']} from {source['url']} ...")
        xml_content = fetch_cmif_data(source['url'])
        if not xml_content:
            print(f"  Failed – skipping")
            continue
        events = parse_cmif_xml(xml_content, source['category'])
        print(f"  Found {len(events)} entries")
        all_new_events.extend(events)

    all_events = base_data + all_new_events

    js_content = f"var calendarData = {json.dumps(all_events, indent=2, ensure_ascii=False)};"
    try:
        with open(calendar_file, 'w', encoding='utf-8') as f:
            f.write(js_content)
        print(f"Total events written: {len(all_events)}")
        return True
    except IOError as e:
        print(f"Error writing calendar data: {e}")
        return False

if __name__ == "__main__":
    integrate_cmif_data()
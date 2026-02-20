#!/usr/bin/env python3
"""
Script to fetch and integrate CMIF printed letters data into calendar
"""

import requests
import xml.etree.ElementTree as ET
import json
import re
from datetime import datetime

def fetch_cmif_data():
    """Fetch CMIF data from GitHub"""
    url = "https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-data/refs/heads/main/import-lists/schnitzler-cmif_tage.xml"
    
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"Error fetching CMIF data: {e}")
        return None

def parse_cmif_xml(xml_content):
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
                
                # Generate a unique ID for printed letters
                # Use date + simplified title as ID
                date_part = when_iso.replace('-', '')
                title_part = re.sub(r'[^a-zA-Z0-9]', '', letter_title)[:20]
                letter_id = f"CMIF_{date_part}_{title_part}"
                
                # Create calendar event
                calendar_event = {
                    'startDate': when_iso,
                    'name': letter_title,
                    'id': f"{letter_id}",  # No .html extension since this opens popup
                    'category': 'gedruckt',
                    'tageszaehler': 0,  # Default value for printed letters
                    'bibliographic': bibliographic_info  # Add bibliographic information
                }
                
                events.append(calendar_event)
                
        return events
        
    except ET.ParseError as e:
        print(f"Error parsing XML: {e}")
        return []

def integrate_cmif_data():
    """Main function to integrate CMIF data"""
    print("Fetching CMIF printed letters data...")
    
    xml_content = fetch_cmif_data()
    if not xml_content:
        print("Failed to fetch CMIF data")
        return False
        
    events = parse_cmif_xml(xml_content)
    print(f"Found {len(events)} printed letters")
    
    if not events:
        print("No events found")
        return False
    
    # Check if calendar data file exists
    import os
    calendar_file = 'html/js-data/calendarData.js'
    if not os.path.exists(calendar_file):
        print(f"Calendar data file {calendar_file} not found!")
        return False
    
    # Load existing calendar data
    try:
        with open(calendar_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Extract existing data (remove JavaScript variable declaration)
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
    
    # Remove existing printed letters to avoid duplicates
    existing_regular_data = [event for event in existing_data if event.get('category') != 'gedruckt']
    print(f"Removed {len(existing_data) - len(existing_regular_data)} existing printed letters")
    
    # Combine data
    all_events = existing_regular_data + events
    
    # Write updated calendar data
    js_content = f"var calendarData = {json.dumps(all_events, indent=2, ensure_ascii=False)};"
    
    try:
        with open('html/js-data/calendarData.js', 'w', encoding='utf-8') as f:
            f.write(js_content)
        
        print(f"Successfully integrated {len(events)} printed letters into calendar data")
        print(f"Total events: {len(all_events)}")
        return True
        
    except IOError as e:
        print(f"Error writing calendar data: {e}")
        return False

if __name__ == "__main__":
    integrate_cmif_data()
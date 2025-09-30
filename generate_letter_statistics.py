#!/usr/bin/env python3
"""
Generate statistics from the letter editions in data/editions/
Creates an XML file with statistics that can be transformed to HTML
"""

import glob
import os
import json
from collections import defaultdict, Counter
from datetime import datetime
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


def extract_year(iso_date):
    """Extract year from ISO date string"""
    try:
        return iso_date.split('-')[0]
    except:
        return None


def get_correspondence_id(doc):
    """Extract correspondence ID from TEI document"""
    try:
        corr_ref = doc.any_xpath('//tei:correspContext/tei:ref[@type="belongsToCorrespondence"]/@target')
        if corr_ref:
            return corr_ref[0].replace('correspondence_', '')
    except:
        pass
    return None


def get_person_name(doc, pmb_id):
    """Get person name from back matter by PMB ID"""
    try:
        person = doc.any_xpath(f'//tei:listPerson/tei:person[@xml:id="{pmb_id}"]//tei:persName[@type="pref"]//text()')
        if person:
            return ' '.join([x.strip() for x in person if x.strip()])
        # Fallback to any persName
        person = doc.any_xpath(f'//tei:listPerson/tei:person[@xml:id="{pmb_id}"]//tei:persName[1]//text()')
        if person:
            return ' '.join([x.strip() for x in person if x.strip()])
    except:
        pass
    return None


def calculate_text_length(doc):
    """Calculate approximate text length from body content"""
    try:
        # Get all text from body, excluding notes
        text = doc.any_xpath('//tei:body//text()[not(ancestor::tei:note)]')
        if text:
            return sum(len(t.strip()) for t in text)
    except:
        pass
    return 0


def count_complete_correspondences():
    """Count complete correspondences from listcorrespondence.xml"""
    try:
        correspondence_file = "./data/indices/listcorrespondence.xml"
        if not os.path.exists(correspondence_file):
            print(f"WARNING: {correspondence_file} not found")
            return 0

        doc = TeiReader(correspondence_file)
        # Count personGrp elements without @ana='planned' and without @xml:id='correspondence_null'
        person_groups = doc.any_xpath("//tei:listPerson/tei:personGrp[not(@ana='planned') and not(@xml:id='correspondence_null')]")
        count = len(person_groups) if person_groups else 0
        print(f"Found {count} complete correspondences")
        return count
    except Exception as e:
        print(f"Error counting correspondences: {e}")
        return 0


def main():
    print("Generating letter statistics from data/editions/...")

    files = sorted(glob.glob("./data/editions/*.xml"))

    if not files:
        print("WARNING: No XML files found in data/editions/")
        print("This script will create an empty statistics file.")

    # Count complete correspondences
    complete_correspondences = count_complete_correspondences()

    # Statistics containers
    stats = {
        'total_letters': 0,
        'complete_correspondences': complete_correspondences,
        'by_year': defaultdict(int),
        'by_correspondence': defaultdict(int),
        'by_sender': defaultdict(int),
        'by_receiver': defaultdict(int),
        'schnitzler_sent': 0,
        'schnitzler_received': 0,
        'third_party': 0,
        'text_length_by_year': defaultdict(int),
        'correspondence_names': {},
        'person_names': {},
        'letters_by_year_and_correspondence': defaultdict(lambda: defaultdict(int)),
        'letters_by_year_and_type': defaultdict(lambda: {'schnitzler_sent': 0, 'schnitzler_received': 0, 'third_party': 0}),
        'by_object_type': defaultdict(int),
        'letters_by_year_and_object_type': defaultdict(lambda: defaultdict(int)),
        'date_range': {'earliest': None, 'latest': None}
    }

    # Process each letter
    for xml_file in tqdm(files, desc="Processing letters"):
        try:
            doc = TeiReader(xml_file)

            # Get basic info
            title = doc.any_xpath('//tei:title[@level="a"]/text()')
            iso_date = doc.any_xpath('//tei:title[@type="iso-date"]/text()')

            if not iso_date:
                continue

            iso_date = iso_date[0]
            year = extract_year(iso_date)

            if not year:
                continue

            stats['total_letters'] += 1
            stats['by_year'][year] += 1

            # Track date range
            if not stats['date_range']['earliest'] or iso_date < stats['date_range']['earliest']:
                stats['date_range']['earliest'] = iso_date
            if not stats['date_range']['latest'] or iso_date > stats['date_range']['latest']:
                stats['date_range']['latest'] = iso_date

            # Get correspondence info
            corr_id = get_correspondence_id(doc)
            if corr_id:
                stats['by_correspondence'][corr_id] += 1
                stats['letters_by_year_and_correspondence'][year][corr_id] += 1

            # Determine letter category (Schnitzler as sender/receiver)
            is_schnitzler_sender = doc.any_xpath('//tei:correspAction[@type="sent"]//tei:persName[@ref="#pmb2121"]')
            is_schnitzler_receiver = doc.any_xpath('//tei:correspAction[@type="received"]//tei:persName[@ref="#pmb2121"]')

            if is_schnitzler_sender:
                stats['schnitzler_sent'] += 1
                stats['letters_by_year_and_type'][year]['schnitzler_sent'] += 1
            elif is_schnitzler_receiver:
                stats['schnitzler_received'] += 1
                stats['letters_by_year_and_type'][year]['schnitzler_received'] += 1
            else:
                stats['third_party'] += 1
                stats['letters_by_year_and_type'][year]['third_party'] += 1

            # Get sender/receiver info
            sender_refs = doc.any_xpath('//tei:correspAction[@type="sent"]//tei:persName/@ref')
            receiver_refs = doc.any_xpath('//tei:correspAction[@type="received"]//tei:persName/@ref')

            for ref in sender_refs:
                pmb_id = ref.replace('#', '')
                stats['by_sender'][pmb_id] += 1
                if pmb_id not in stats['person_names']:
                    name = get_person_name(doc, pmb_id)
                    if name:
                        stats['person_names'][pmb_id] = name

            for ref in receiver_refs:
                pmb_id = ref.replace('#', '')
                stats['by_receiver'][pmb_id] += 1
                if pmb_id not in stats['person_names']:
                    name = get_person_name(doc, pmb_id)
                    if name:
                        stats['person_names'][pmb_id] = name

            # Calculate text length
            text_length = calculate_text_length(doc)
            stats['text_length_by_year'][year] += text_length

            # Get object type
            object_type = doc.any_xpath('//tei:sourceDesc/tei:listWit/tei:witness/tei:objectType/@corresp')
            if object_type:
                # Extract just the type without any prefix
                type_value = object_type[0].strip()
                if type_value:
                    stats['by_object_type'][type_value] += 1
                    stats['letters_by_year_and_object_type'][year][type_value] += 1

        except Exception as e:
            print(f"Error processing {xml_file}: {e}")
            continue

    # Convert defaultdicts to regular dicts for JSON serialization
    stats_output = {
        'total_letters': stats['total_letters'],
        'complete_correspondences': stats['complete_correspondences'],
        'by_year': dict(sorted(stats['by_year'].items())),
        'by_correspondence': dict(sorted(stats['by_correspondence'].items(), key=lambda x: x[1], reverse=True)),
        'by_sender': dict(sorted(stats['by_sender'].items(), key=lambda x: x[1], reverse=True)),
        'by_receiver': dict(sorted(stats['by_receiver'].items(), key=lambda x: x[1], reverse=True)),
        'schnitzler_sent': stats['schnitzler_sent'],
        'schnitzler_received': stats['schnitzler_received'],
        'third_party': stats['third_party'],
        'text_length_by_year': dict(sorted(stats['text_length_by_year'].items())),
        'person_names': stats['person_names'],
        'date_range': stats['date_range'],
        'letters_by_year_and_correspondence': {
            year: dict(corr_data)
            for year, corr_data in sorted(stats['letters_by_year_and_correspondence'].items())
        },
        'letters_by_year_and_type': {
            year: dict(type_data)
            for year, type_data in sorted(stats['letters_by_year_and_type'].items())
        },
        'by_object_type': dict(sorted(stats['by_object_type'].items(), key=lambda x: x[1], reverse=True)),
        'letters_by_year_and_object_type': {
            year: dict(obj_data)
            for year, obj_data in sorted(stats['letters_by_year_and_object_type'].items())
        }
    }

    # Create output directory
    out_path = os.path.join("html", "js-data")
    os.makedirs(out_path, exist_ok=True)

    # Write JSON file
    json_file = os.path.join(out_path, "letterStatistics.json")
    print(f"\nWriting statistics to {json_file}")
    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(stats_output, f, ensure_ascii=False, indent=2)

    # Write JavaScript file for direct inclusion
    js_file = os.path.join(out_path, "letterStatistics.js")
    print(f"Writing statistics to {js_file}")
    with open(js_file, 'w', encoding='utf-8') as f:
        f.write(f"var letterStatistics = {json.dumps(stats_output, ensure_ascii=False, indent=2)};")

    # Create XML file for XSLT transformation
    xml_file = os.path.join("data", "meta", "statistiken-dynamisch.xml")
    print(f"Writing statistics XML to {xml_file}")

    with open(xml_file, 'w', encoding='utf-8') as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<TEI xmlns="http://www.tei-c.org/ns/1.0">\n')
        f.write('  <teiHeader>\n')
        f.write('    <fileDesc>\n')
        f.write('      <titleStmt>\n')
        f.write('        <title level="s">Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren</title>\n')
        f.write('        <title level="a">Statistiken zur Korrespondenz (dynamisch generiert)</title>\n')
        f.write('      </titleStmt>\n')
        f.write('      <publicationStmt>\n')
        f.write('        <publisher>Austrian Centre for Digital Humanities</publisher>\n')
        f.write('        <pubPlace>Vienna</pubPlace>\n')
        f.write(f'        <date when="{datetime.now().strftime("%Y-%m-%d")}">{datetime.now().strftime("%Y")}</date>\n')
        f.write('      </publicationStmt>\n')
        f.write('      <sourceDesc>\n')
        f.write('        <p>Automatisch generiert aus den Briefeditionen.</p>\n')
        f.write('      </sourceDesc>\n')
        f.write('    </fileDesc>\n')
        f.write('  </teiHeader>\n')
        f.write('  <text>\n')
        f.write('    <body>\n')
        f.write('      <div type="statistics">\n')
        f.write(f'        <p>Gesamtanzahl edierter Briefe: <num>{stats_output["total_letters"]}</num></p>\n')
        f.write(f'        <p>Briefe von Schnitzler: <num>{stats_output["schnitzler_sent"]}</num></p>\n')
        f.write(f'        <p>Briefe an Schnitzler: <num>{stats_output["schnitzler_received"]}</num></p>\n')
        f.write(f'        <p>Umfeldbriefe: <num>{stats_output["third_party"]}</num></p>\n')

        if stats_output['date_range']['earliest'] and stats_output['date_range']['latest']:
            f.write(f'        <p>Zeitraum: {stats_output["date_range"]["earliest"]} bis {stats_output["date_range"]["latest"]}</p>\n')

        f.write('      </div>\n')
        f.write('      <div type="by_year">\n')
        f.write('        <head>Briefe nach Jahren</head>\n')
        f.write('        <table>\n')
        f.write('          <row role="label">\n')
        f.write('            <cell>Jahr</cell>\n')
        f.write('            <cell>Anzahl</cell>\n')
        f.write('          </row>\n')
        for year, count in sorted(stats_output['by_year'].items()):
            f.write(f'          <row>\n')
            f.write(f'            <cell>{year}</cell>\n')
            f.write(f'            <cell>{count}</cell>\n')
            f.write(f'          </row>\n')
        f.write('        </table>\n')
        f.write('      </div>\n')

        f.write('      <div type="top_correspondences">\n')
        f.write('        <head>Häufigste Korrespondenzen</head>\n')
        f.write('        <list>\n')
        for corr_id, count in list(stats_output['by_correspondence'].items())[:10]:
            f.write(f'          <item><label>correspondence_{corr_id}</label>: <num>{count}</num> Briefe</item>\n')
        f.write('        </list>\n')
        f.write('      </div>\n')

        f.write('      <div type="data_export">\n')
        f.write('        <p>Die vollständigen Statistikdaten sind verfügbar als:\n')
        f.write('          <list>\n')
        f.write('            <item><ref target="../js-data/letterStatistics.json">JSON-Datei</ref></item>\n')
        f.write('            <item><ref target="../js-data/letterStatistics.js">JavaScript-Datei</ref></item>\n')
        f.write('          </list>\n')
        f.write('        </p>\n')
        f.write('      </div>\n')
        f.write('    </body>\n')
        f.write('  </text>\n')
        f.write('</TEI>\n')

    print("\n=== Statistics Summary ===")
    print(f"Total letters: {stats_output['total_letters']}")
    print(f"From Schnitzler: {stats_output['schnitzler_sent']}")
    print(f"To Schnitzler: {stats_output['schnitzler_received']}")
    print(f"Third party: {stats_output['third_party']}")
    print(f"Date range: {stats_output['date_range']['earliest']} to {stats_output['date_range']['latest']}")
    print(f"Years covered: {len(stats_output['by_year'])}")
    print(f"Different correspondences: {len(stats_output['by_correspondence'])}")
    print("\nTop 5 correspondences:")
    for i, (corr_id, count) in enumerate(list(stats_output['by_correspondence'].items())[:5], 1):
        print(f"  {i}. correspondence_{corr_id}: {count} letters")

    print("\n✓ Statistics generation complete!")


if __name__ == "__main__":
    main()
#!/usr/bin/env python3
"""
Test script to check if text_areas are correctly classified
"""
import glob
from acdh_tei_pyutils.tei import TeiReader

files = sorted(glob.glob('./data/editions/*.xml'))[:5]  # Test first 5 files

print("Testing text_areas classification...\n")

for x in files:
    print(f"\n{'='*80}")
    print(f"File: {x}")
    print('='*80)

    doc = TeiReader(x)
    text_areas = []

    # Check for Editionstext (body text excluding commentary notes)
    editionstext_nodes = doc.any_xpath(
        ".//tei:body//text()[not(ancestor::tei:note[@type='commentary'])]"
    )
    editionstext_has_content = any(node.strip() for node in editionstext_nodes) if editionstext_nodes else False

    print(f"\nEditionstext nodes found: {len(editionstext_nodes) if editionstext_nodes else 0}")
    if editionstext_nodes:
        sample = [node.strip()[:50] for node in editionstext_nodes if node.strip()][:3]
        print(f"Sample text: {sample}")

    if editionstext_has_content:
        text_areas.append("Editionstext")

    # Check for Kommentar (commentary notes in body)
    kommentar_nodes = doc.any_xpath(
        ".//tei:body//tei:note[@type='commentary']//text()"
    )
    kommentar_has_content = any(node.strip() for node in kommentar_nodes) if kommentar_nodes else False

    print(f"\nKommentar nodes found: {len(kommentar_nodes) if kommentar_nodes else 0}")
    if kommentar_nodes:
        sample = [node.strip()[:50] for node in kommentar_nodes if node.strip()][:3]
        print(f"Sample text: {sample}")

    if kommentar_has_content:
        text_areas.append("Kommentar")

    # Check for Objektbeschreibung (sourceDesc)
    objektbeschreibung_nodes = doc.any_xpath(
        ".//tei:sourceDesc//text()"
    )
    objektbeschreibung_has_content = any(node.strip() for node in objektbeschreibung_nodes) if objektbeschreibung_nodes else False

    print(f"\nObjektbeschreibung nodes found: {len(objektbeschreibung_nodes) if objektbeschreibung_nodes else 0}")
    if objektbeschreibung_nodes:
        sample = [node.strip()[:50] for node in objektbeschreibung_nodes if node.strip()][:3]
        print(f"Sample text: {sample}")

    if objektbeschreibung_has_content:
        text_areas.append("Objektbeschreibung")

    print(f"\n✓ TEXT AREAS: {text_areas}")

    if not text_areas:
        print("⚠ WARNING: No text areas detected!")

print("\n" + "="*80)
print("Test completed")

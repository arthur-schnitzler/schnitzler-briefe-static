#!/usr/bin/env python3
"""
Test to check if text_areas filter logic is correct
"""
import glob
import re
from acdh_tei_pyutils.tei import TeiReader

def extract_fulltext_with_spacing(root_node):
    """Simplified extraction."""
    text = ' '.join(root_node.xpath('.//text()', namespaces={'tei': 'http://www.tei-c.org/ns/1.0'}))
    return re.sub(r'\s+', ' ', text).strip()

files = sorted(glob.glob('./data/editions/*.xml'))[:10]

print("Checking text_areas logic...\n")

issues = []

for x in files:
    doc = TeiReader(x)
    body = doc.any_xpath(".//tei:body")[0]

    text_areas = []

    # Editionstext: Check if there's body text
    editionstext_elements = doc.any_xpath(
        ".//tei:body//*[not(self::tei:note[@type='commentary']) and not(ancestor::tei:note[@type='commentary'])]"
    )
    if editionstext_elements:
        editionstext = extract_fulltext_with_spacing(body)
        for commentary in doc.any_xpath(".//tei:body//tei:note[@type='commentary']"):
            commentary_text = extract_fulltext_with_spacing(commentary)
            editionstext = editionstext.replace(commentary_text, " ")
        editionstext = re.sub(r'\s+', ' ', editionstext).strip()
        if editionstext:
            text_areas.append("Editionstext")

    # Kommentar: Check if there are commentary notes
    kommentar_elements = doc.any_xpath(".//tei:body//tei:note[@type='commentary']")
    if kommentar_elements:
        kommentar_texts = [extract_fulltext_with_spacing(elem) for elem in kommentar_elements]
        kommentar = " ".join(kommentar_texts).strip()
        if kommentar:
            text_areas.append("Kommentar")

    # Now check: if a document has text_areas = ["Kommentar"],
    # it means it should ONLY have commentary, no editionstext
    if text_areas == ["Kommentar"]:
        issues.append({
            'file': x.split('/')[-1],
            'issue': 'Document has ONLY Kommentar, no Editionstext',
            'editionstext_len': len(editionstext) if 'editionstext' in locals() else 0,
            'kommentar_len': len(kommentar) if 'kommentar' in locals() else 0
        })

    # Also check if both are present
    if text_areas == ["Editionstext", "Kommentar"]:
        # This is expected - document has both
        pass

    print(f"{x.split('/')[-1]}: {text_areas}")

print("\n" + "="*80)
if issues:
    print("⚠️  Issues found:")
    for issue in issues:
        print(f"\n{issue['file']}:")
        print(f"  {issue['issue']}")
        print(f"  Editionstext length: {issue['editionstext_len']}")
        print(f"  Kommentar length: {issue['kommentar_len']}")
else:
    print("✓ No issues found - text_areas logic is correct")

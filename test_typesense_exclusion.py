#!/usr/bin/env python3
"""
Test script to verify tei:subst/tei:del exclusion works correctly
"""

import xml.etree.ElementTree as ET
from make_typesense_index import extract_fulltext_with_spacing

# Test XML with various tei:subst/tei:del scenarios
test_xml = """<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:tei="http://www.tei-c.org/ns/1.0">
    <tei:body>
        <tei:p>This is normal text.</tei:p>
        <tei:p>Text with <tei:subst><tei:del>error</tei:del><tei:add>correction</tei:add></tei:subst> should exclude single word del.</tei:p>
        <tei:p>Text with <tei:subst><tei:del>multiple word deletion</tei:del><tei:add>correction</tei:add></tei:subst> should keep multi-word del.</tei:p>
        <tei:p>Text with <tei:del>standalone deletion</tei:del> should keep non-subst del.</tei:p>
    </tei:body>
</root>"""

def test_exclusion():
    """Test the exclusion of tei:subst/tei:del elements without spaces"""

    # Parse the test XML
    root = ET.fromstring(test_xml)
    body = root.find('.//{http://www.tei-c.org/ns/1.0}body')

    if body is None:
        print("Error: Could not find tei:body element")
        return False

    # Extract fulltext
    result = extract_fulltext_with_spacing(body)

    print("Extracted text:")
    print(repr(result))
    print()
    print("Formatted text:")
    print(result)
    print()

    # Check if the exclusion worked correctly
    checks = [
        ("normal text should be included", "This is normal text" in result),
        ("single word del should be excluded", "error" not in result),
        ("correction should be included", "correction" in result),
        ("multi-word del should be included", "multiple word deletion" in result),
        ("standalone del should be included", "standalone deletion" in result),
    ]

    all_passed = True
    for description, passed in checks:
        status = "✓ PASS" if passed else "✗ FAIL"
        print(f"{status}: {description}")
        if not passed:
            all_passed = False

    return all_passed

if __name__ == "__main__":
    print("Testing tei:subst/tei:del exclusion...")
    print("=" * 50)

    success = test_exclusion()

    print("\n" + "=" * 50)
    if success:
        print("✓ All tests passed!")
    else:
        print("✗ Some tests failed!")

    print("=" * 50)
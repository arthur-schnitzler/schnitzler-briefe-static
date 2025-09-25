#!/usr/bin/env python3
"""
Test script to verify tei:subst/tei:del exclusion works correctly
"""

import xml.etree.ElementTree as ET

def extract_fulltext_with_spacing(root_node, tag_blacklist=None):
    """
    Extract fulltext with proper spacing around block-level TEI elements.
    Excludes tei:subst/tei:del elements that don't contain spaces.
    """
    if tag_blacklist is None:
        tag_blacklist = []

    # Elements that should have spaces around them
    block_elements = {
        'p', 'salute', 'dateline', 'closer', 'seg', 'opener', 'div', 'head'
    }

    def extract_text_recursive(element):
        # Handle the case where element.tag might not be a string
        try:
            if hasattr(element.tag, 'split'):
                element_tag_name = element.tag.split('}')[-1]
            else:
                element_tag_name = str(element.tag).split('}')[-1]
        except (AttributeError, TypeError):
            element_tag_name = ''

        if element_tag_name in tag_blacklist:
            return ""

        # Check if this is a tei:del element within tei:subst that should be excluded
        # Exclude tei:del elements within tei:subst that don't contain spaces
        if element_tag_name == 'del':
            parent = element.getparent()
            if parent is not None:
                try:
                    parent_tag = parent.tag.split('}')[-1] if hasattr(parent.tag, 'split') else str(parent.tag).split('}')[-1]
                    if parent_tag == 'subst':
                        # Get all text content of this del element
                        del_text = ''.join(element.itertext())
                        if del_text and ' ' not in del_text:
                            # Skip this del element if it doesn't contain spaces
                            return ""
                except (AttributeError, TypeError):
                    pass

        text_parts = []

        # Add element text
        if element.text:
            text_parts.append(element.text)

        # Process children
        for child in element:
            # Handle the case where child.tag might not be a string
            try:
                if hasattr(child.tag, 'split'):
                    tag_name = child.tag.split('}')[-1]  # Remove namespace
                else:
                    tag_name = str(child.tag).split('}')[-1]
            except (AttributeError, TypeError):
                # Skip if we can't determine the tag name
                if hasattr(child, 'tail') and child.tail:
                    text_parts.append(child.tail)
                continue

            # Handle space elements
            if tag_name == 'space':
                unit = child.get('unit', '')
                if unit == 'chars':
                    # Add space for char-based spacing elements
                    text_parts.append(" ")
                continue

            # Add space before block elements
            if tag_name in block_elements:
                text_parts.append(" ")

            # Process child recursively
            child_text = extract_text_recursive(child)
            if child_text:
                text_parts.append(child_text)

            # Add space after block elements
            if tag_name in block_elements:
                text_parts.append(" ")

            # Add tail text
            if child.tail:
                text_parts.append(child.tail)

        return "".join(text_parts)

    result = extract_text_recursive(root_node)
    # Clean up multiple spaces
    import re
    result = re.sub(r'\s+', ' ', result).strip()
    return result


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
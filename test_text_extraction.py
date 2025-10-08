#!/usr/bin/env python3
"""
Test script to verify text extraction is correctly separated
"""
import glob
import re
import copy
from acdh_tei_pyutils.tei import TeiReader

def extract_fulltext_with_spacing(root_node, tag_blacklist=None):
    """
    Extract fulltext with proper spacing around block-level TEI elements.
    """
    if tag_blacklist is None:
        tag_blacklist = []

    block_elements = {
        'p', 'salute', 'dateline', 'closer', 'seg', 'opener', 'div', 'head'
    }

    def extract_text_recursive(element):
        try:
            if hasattr(element.tag, 'split'):
                element_tag_name = element.tag.split('}')[-1]
            else:
                element_tag_name = str(element.tag).split('}')[-1]
        except (AttributeError, TypeError):
            element_tag_name = ''

        if element_tag_name in tag_blacklist:
            return ""

        if element_tag_name == 'del':
            try:
                parent = element.getparent() if hasattr(element, 'getparent') else None
                if parent is not None:
                    parent_tag = parent.tag.split('}')[-1] if hasattr(parent.tag, 'split') else str(parent.tag).split('}')[-1]
                    if parent_tag == 'subst':
                        if hasattr(element, 'itertext'):
                            del_text = ''.join(element.itertext())
                        else:
                            del_text = element.text or ''
                            for child in element:
                                if child.text:
                                    del_text += child.text
                                if child.tail:
                                    del_text += child.tail
                        if del_text and ' ' not in del_text:
                            return ""
            except (AttributeError, TypeError):
                pass

        text_parts = []

        if element.text:
            text_parts.append(element.text)

        for child in element:
            try:
                if hasattr(child.tag, 'split'):
                    tag_name = child.tag.split('}')[-1]
                else:
                    tag_name = str(child.tag).split('}')[-1]
            except (AttributeError, TypeError):
                if hasattr(child, 'tail') and child.tail:
                    text_parts.append(child.tail)
                continue

            if tag_name == 'space':
                unit = child.get('unit', '')
                if unit == 'chars':
                    text_parts.append(" ")
                continue

            if tag_name in block_elements:
                text_parts.append(" ")

            child_text = extract_text_recursive(child)
            if child_text:
                text_parts.append(child_text)

            if tag_name in block_elements:
                text_parts.append(" ")

            if child.tail:
                text_parts.append(child.tail)

        return "".join(text_parts)

    result = extract_text_recursive(root_node)
    result = re.sub(r'\s+', ' ', result).strip()
    return result


files = sorted(glob.glob('./data/editions/*.xml'))[:3]

print("Testing text extraction separation...\n")

for x in files:
    print(f"\n{'='*80}")
    print(f"File: {x}")
    print('='*80)

    doc = TeiReader(x)
    body = doc.any_xpath(".//tei:body")[0]

    # Method 1: Current approach (extract full body, then remove commentary)
    editionstext_current = extract_fulltext_with_spacing(body)
    for commentary in doc.any_xpath(".//tei:body//tei:note[@type='commentary']"):
        commentary_text = extract_fulltext_with_spacing(commentary)
        editionstext_current = editionstext_current.replace(commentary_text, " ")
    editionstext_current = re.sub(r'\s+', ' ', editionstext_current).strip()

    # Method 2: Better approach (extract only non-commentary nodes)
    body_copy = copy.deepcopy(body)
    for commentary in body_copy.xpath(".//tei:note[@type='commentary']", namespaces={'tei': 'http://www.tei-c.org/ns/1.0'}):
        commentary.getparent().remove(commentary)
    editionstext_clean = extract_fulltext_with_spacing(body_copy)

    # Extract commentary
    kommentar_elements = doc.any_xpath(".//tei:body//tei:note[@type='commentary']")
    kommentar = " ".join([extract_fulltext_with_spacing(elem) for elem in kommentar_elements]).strip()

    print(f"\n--- Editionstext (current method, first 200 chars) ---")
    print(editionstext_current[:200])
    print(f"\n--- Editionstext (clean method, first 200 chars) ---")
    print(editionstext_clean[:200])
    print(f"\n--- Kommentar (first 200 chars) ---")
    print(kommentar[:200] if kommentar else "(no commentary)")

    # Check if commentary text is still in editionstext
    if kommentar:
        kommentar_snippet = kommentar.split()[:10]
        kommentar_test = " ".join(kommentar_snippet)

        in_current = kommentar_test in editionstext_current
        in_clean = kommentar_test in editionstext_clean

        print(f"\n⚠ Commentary snippet '{kommentar_test[:50]}...' found in:")
        print(f"  - Current method: {in_current}")
        print(f"  - Clean method: {in_clean}")

print("\n" + "="*80)
print("Test completed")

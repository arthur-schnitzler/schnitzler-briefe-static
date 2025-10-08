#!/usr/bin/env python3
"""
Test to verify commentary extraction is correct and isolated
"""
import glob
import re
from acdh_tei_pyutils.tei import TeiReader

def extract_fulltext_with_spacing(root_node, tag_blacklist=None):
    """Extract fulltext with proper spacing."""
    if tag_blacklist is None:
        tag_blacklist = []

    block_elements = {'p', 'salute', 'dateline', 'closer', 'seg', 'opener', 'div', 'head'}

    def extract_text_recursive(element):
        try:
            element_tag_name = element.tag.split('}')[-1] if hasattr(element.tag, 'split') else str(element.tag).split('}')[-1]
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
                        del_text = ''.join(element.itertext()) if hasattr(element, 'itertext') else (element.text or '')
                        if del_text and ' ' not in del_text:
                            return ""
            except (AttributeError, TypeError):
                pass

        text_parts = []
        if element.text:
            text_parts.append(element.text)

        for child in element:
            try:
                tag_name = child.tag.split('}')[-1] if hasattr(child.tag, 'split') else str(child.tag).split('}')[-1]
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


# Test with files that have commentary
files = sorted(glob.glob('./data/editions/*.xml'))[:10]

print("Testing commentary extraction isolation...\n")

for x in files:
    doc = TeiReader(x)
    body = doc.any_xpath(".//tei:body")[0]

    # Extract commentary
    kommentar_elements = doc.any_xpath(".//tei:body//tei:note[@type='commentary']")
    if not kommentar_elements:
        continue

    kommentar = " ".join([extract_fulltext_with_spacing(elem) for elem in kommentar_elements]).strip()

    # Extract editionstext (full body, then remove commentary)
    editionstext = extract_fulltext_with_spacing(body)
    for commentary in kommentar_elements:
        commentary_text = extract_fulltext_with_spacing(commentary)
        editionstext = editionstext.replace(commentary_text, " ")
    editionstext = re.sub(r'\s+', ' ', editionstext).strip()

    print(f"\n{'='*80}")
    print(f"File: {x.split('/')[-1]}")
    print('='*80)

    print(f"\nKommentar length: {len(kommentar)} chars")
    print(f"Editionstext length: {len(editionstext)} chars")

    # Take some unique words from commentary
    kommentar_words = set(re.findall(r'\b\w{6,}\b', kommentar.lower()))
    editionstext_words = set(re.findall(r'\b\w{6,}\b', editionstext.lower()))

    # Find words that appear ONLY in commentary
    only_in_commentary = kommentar_words - editionstext_words

    # Find words that appear in BOTH
    in_both = kommentar_words & editionstext_words

    print(f"\nWords only in commentary: {len(only_in_commentary)}")
    if only_in_commentary:
        print(f"  Examples: {list(only_in_commentary)[:5]}")

    print(f"Words in both commentary and editionstext: {len(in_both)}")
    if in_both:
        print(f"  Examples: {list(in_both)[:5]}")

    # Check if any commentary text leaked into editionstext
    # Take first 50 chars of commentary and check if it's in editionstext
    kommentar_snippet = ' '.join(kommentar.split()[:8])
    if kommentar_snippet in editionstext:
        print(f"\n⚠️  WARNING: Commentary snippet found in editionstext!")
        print(f"  Snippet: '{kommentar_snippet}'")

print("\n" + "="*80)
print("Test completed")

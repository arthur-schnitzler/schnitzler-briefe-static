import glob
import os
import re
from collections import Counter
import lxml.etree as ET
from tqdm import tqdm

TEI_NS = 'http://www.tei-c.org/ns/1.0'
LANGES_S_TAG = f'{{{TEI_NS}}}c'


def get_word_around(elem):
    """Reconstruct the word containing a <c rendition="#langesS"> element."""
    prev = elem.getprevious()
    if prev is not None:
        before_text = prev.tail or ''
    else:
        before_text = elem.getparent().text or ''

    after_text = elem.tail or ''

    m_before = re.search(r'\w+$', before_text, re.UNICODE)
    before_part = m_before.group(0) if m_before else ''

    m_after = re.match(r'\w+', after_text, re.UNICODE)
    after_part = m_after.group(0) if m_after else ''

    s_char = elem.text or 's'
    return (before_part + s_char + after_part).lower()


files = sorted(glob.glob('./data/editions/*.xml'))
word_counter = Counter()

for filepath in tqdm(files, desc='Verarbeite Editions-Dateien'):
    try:
        tree = ET.parse(filepath)
        root = tree.getroot()
        for elem in root.iter(LANGES_S_TAG):
            if elem.get('rendition') == '#langesS':
                word = get_word_around(elem)
                if word:
                    word_counter[word] += 1
    except ET.XMLSyntaxError as e:
        print(f"Fehler beim Parsen von {filepath}: {e}")

total = sum(word_counter.values())
unique = len(word_counter)

root_el = ET.Element('langesS')
meta_el = ET.SubElement(root_el, 'meta')
ET.SubElement(meta_el, 'totalOccurrences').text = str(total)
ET.SubElement(meta_el, 'uniqueWords').text = str(unique)

words_el = ET.SubElement(root_el, 'words')
for word, count in sorted(word_counter.items(), key=lambda x: -x[1]):
    w_el = ET.SubElement(words_el, 'word')
    w_el.set('count', str(count))
    w_el.text = word

tree_out = ET.ElementTree(root_el)
ET.indent(tree_out, space='  ')
os.makedirs('./data/meta', exist_ok=True)
tree_out.write('./data/meta/langes_s.xml', encoding='UTF-8', xml_declaration=True)

print(f"Fertig: {total} Vorkommen, {unique} einzigartige Wörter.")

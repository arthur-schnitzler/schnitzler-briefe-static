import glob
import os
import re
from collections import Counter
import lxml.etree as ET
from tqdm import tqdm

TEI_NS = 'http://www.tei-c.org/ns/1.0'
C_TAG = f'{{{TEI_NS}}}c'

# Sonderzeichen, die ausgewertet werden: rendition → Eigenschaften.
# 'original' ist die Glyphe der Handschrift, 'modern' die heutige Umschrift.
SPECIAL_RENDITIONS = {
    '#langesS': {
        'key': 'langesS',
        'label': 'Langes ſ',
        'original': 'ſ',
        'modern': 's',
    },
    '#gemination-m': {
        'key': 'gemination-m',
        'label': 'Gemination m̅',
        'original': 'm̅',
        'modern': 'mm',
    },
    '#gemination-n': {
        'key': 'gemination-n',
        'label': 'Gemination n̅',
        'original': 'n̅',
        'modern': 'nn',
    },
}

# Elemente, die als Wortgrenze gelten (z.B. <lb/>, <pb/> etc.)
WORD_BOUNDARY_TAGS = {
    f'{{{TEI_NS}}}lb',
    f'{{{TEI_NS}}}pb',
    f'{{{TEI_NS}}}cb',
}

# Elemente, deren Inhalt vollständig übersprungen wird (Wortgrenze einfügen,
# Inhalt ignorieren) – editorische Zutaten, die nicht Teil des Lesetexts sind.
SKIP_TAGS = {
    f'{{{TEI_NS}}}note',
    f'{{{TEI_NS}}}fw',      # Bogwort / Kustode
    f'{{{TEI_NS}}}figDesc',  # Bildbeschreibung
}

# Elemente, die Inline-Text enthalten können (kein Wortbruch)
INLINE_TAGS = {
    f'{{{TEI_NS}}}hi',
    f'{{{TEI_NS}}}rs',
    f'{{{TEI_NS}}}persName',
    f'{{{TEI_NS}}}placeName',
    f'{{{TEI_NS}}}orgName',
    f'{{{TEI_NS}}}date',
    f'{{{TEI_NS}}}time',
    f'{{{TEI_NS}}}title',
    f'{{{TEI_NS}}}add',
    f'{{{TEI_NS}}}del',
    f'{{{TEI_NS}}}supplied',
    f'{{{TEI_NS}}}unclear',
    f'{{{TEI_NS}}}choice',
    f'{{{TEI_NS}}}abbr',
    f'{{{TEI_NS}}}expan',
    f'{{{TEI_NS}}}orig',
    f'{{{TEI_NS}}}reg',
    f'{{{TEI_NS}}}corr',
    f'{{{TEI_NS}}}sic',
    f'{{{TEI_NS}}}c',  # andere <c>-Elemente (z.B. weiteres langes S im selben Wort)
}

# Wortgrenzen: Leerzeichen, Satzzeichen, festes Leerzeichen, Anführungszeichen
WORD_BOUNDARY_RE = re.compile(r'[\s\u00a0\u202f,\.;:!?\(\)\[\]{}\"\'\-–—/\\|»«„\u201c\u201d‹›]')

# Container-Elemente, an deren Anfang ein neues Wort beginnt
BLOCK_TAGS = {
    f'{{{TEI_NS}}}p',
    f'{{{TEI_NS}}}closer',
    f'{{{TEI_NS}}}salute',
    f'{{{TEI_NS}}}seg',
    f'{{{TEI_NS}}}dateline',
    f'{{{TEI_NS}}}opener',
    f'{{{TEI_NS}}}signed',
}


def serialize_inline(node, target_elem, parts, placeholder='§'):
    """
    Serialisiert einen Block-Knoten in eine Liste von (text, elem_or_None)-Tupeln,
    wobei target_elem durch den Platzhalter markiert wird.
    Gibt True zurück, wenn target_elem gefunden wurde.
    """
    # Text vor dem ersten Kind
    if node.text:
        parts.append(node.text)

    found = False
    for child in node:
        tag = child.tag
        if child is target_elem:
            parts.append(placeholder)
            found = True
            if child.tail:
                parts.append(child.tail)
        elif tag in WORD_BOUNDARY_TAGS:
            # <lb/> etc. → Wortgrenze einfügen
            parts.append(' ')
            if child.tail:
                parts.append(child.tail)
        elif f'{{{TEI_NS}}}space' == tag:
            # <space/> → Wortgrenze
            parts.append(' ')
            if child.tail:
                parts.append(child.tail)
        elif tag == C_TAG and child.get('rendition') in SPECIAL_RENDITIONS:
            # Weiteres Sonderzeichen im gleichen Wort → direkt die Original-
            # Glyphe einsetzen (keinesfalls den Textinhalt, z.B. 's' ≠ 'ſ')
            parts.append(SPECIAL_RENDITIONS[child.get('rendition')]['original'])
            if child.tail:
                parts.append(child.tail)
        elif tag in SKIP_TAGS:
            # Editorisches Element (z.B. <note>): Wortgrenze einfügen,
            # Inhalt komplett überspringen
            parts.append(' ')
            if child.tail:
                parts.append(child.tail)
        elif tag in INLINE_TAGS or tag not in BLOCK_TAGS:
            # Inline-Element: Inhalt einbetten
            sub_found = serialize_inline(child, target_elem, parts, placeholder)
            if sub_found:
                found = True
            if child.tail:
                parts.append(child.tail)
        else:
            # Block-Element → Wortgrenze
            parts.append(' ')
            sub_found = serialize_inline(child, target_elem, parts, placeholder)
            if sub_found:
                found = True
            parts.append(' ')
            if child.tail:
                parts.append(child.tail)

    return found


def get_word_around(elem, glyph):
    """
    Findet das vollständige Wort um ein Sonderzeichen-<c>-Element.
    Traversiert aufwärts bis zum nächsten Block-Container und serialisiert
    dessen Textinhalt, um korrekte Wortgrenzen zu ermitteln.
    `glyph` ist die Original-Glyphe, die anstelle des Elements eingesetzt
    wird (z.B. 'ſ' oder 'm̅').
    """
    # Block-Container finden
    parent = elem.getparent()
    container = parent
    while container is not None and container.tag not in BLOCK_TAGS:
        container = container.getparent()
    if container is None:
        container = parent  # Fallback

    placeholder = '\x00'  # Null-Byte als sicherer Platzhalter
    parts = []
    found = serialize_inline(container, elem, parts, placeholder)

    if not found:
        return None

    text = ''.join(parts)
    pos = text.find(placeholder)
    if pos < 0:
        return None

    # Rückwärts nach Wortgrenze suchen
    before = text[:pos]
    after = text[pos + 1:]

    # Wortgrenze rückwärts
    m_before = WORD_BOUNDARY_RE.search(before)
    if m_before:
        # Letzte Grenze finden
        last_boundary = -1
        for m in WORD_BOUNDARY_RE.finditer(before):
            last_boundary = m.end()
        before_part = before[last_boundary:] if last_boundary >= 0 else before
    else:
        before_part = before

    # Wortgrenze vorwärts
    m_after = WORD_BOUNDARY_RE.search(after)
    after_part = after[:m_after.start()] if m_after else after

    word = before_part + glyph + after_part

    # Leerstring oder nur Satzzeichen ignorieren
    if not re.search(r'\w', word, re.UNICODE):
        return None

    return word


def modern_form(word):
    """
    Übersetzt die Original-Glyphen in die heutige Umschrift
    (ſ → s, m̅ → mm, n̅ → nn).
    """
    for props in SPECIAL_RENDITIONS.values():
        word = word.replace(props['original'], props['modern'])
    return word


# ── Hauptprogramm ────────────────────────────────────────────────────────────

files = sorted(glob.glob('./data/editions/*.xml'))
word_counters = {r: Counter() for r in SPECIAL_RENDITIONS}

for filepath in tqdm(files, desc='Verarbeite Editions-Dateien'):
    try:
        tree = ET.parse(filepath)
        root = tree.getroot()
        for elem in root.iter(C_TAG):
            rendition = elem.get('rendition')
            if rendition in SPECIAL_RENDITIONS:
                word = get_word_around(elem, SPECIAL_RENDITIONS[rendition]['original'])
                if word:
                    word_counters[rendition][word] += 1
    except ET.XMLSyntaxError as e:
        print(f"Fehler beim Parsen von {filepath}: {e}")

root_el = ET.Element('sonderzeichen')

for rendition, props in SPECIAL_RENDITIONS.items():
    counter = word_counters[rendition]
    total = sum(counter.values())
    unique = len(counter)

    type_el = ET.SubElement(root_el, 'charType')
    type_el.set('type', props['key'])
    type_el.set('label', props['label'])
    type_el.set('char', props['original'])
    meta_el = ET.SubElement(type_el, 'meta')
    ET.SubElement(meta_el, 'totalOccurrences').text = str(total)
    ET.SubElement(meta_el, 'uniqueWords').text = str(unique)
    words_el = ET.SubElement(type_el, 'words')

    for word, count in sorted(counter.items(), key=lambda x: -x[1]):
        w_el = ET.SubElement(words_el, 'word')
        w_el.set('count', str(count))
        # Text: heutige Umschrift; @original: Glyphen wie kodiert
        w_el.text = modern_form(word)
        w_el.set('original', word)

    print(f"{props['label']}: {total} Vorkommen, {unique} einzigartige Wörter.")

tree_out = ET.ElementTree(root_el)
ET.indent(tree_out, space='  ')
os.makedirs('./data/meta', exist_ok=True)
tree_out.write('./data/meta/sonderzeichen.xml', encoding='UTF-8', xml_declaration=True)

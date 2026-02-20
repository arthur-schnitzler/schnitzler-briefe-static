import glob
import os
import re
from collections import Counter
import lxml.etree as ET
from tqdm import tqdm

TEI_NS = 'http://www.tei-c.org/ns/1.0'
LANGES_S_TAG = f'{{{TEI_NS}}}c'

# Elemente, die als Wortgrenze gelten (z.B. <lb/>, <pb/> etc.)
WORD_BOUNDARY_TAGS = {
    f'{{{TEI_NS}}}lb',
    f'{{{TEI_NS}}}pb',
    f'{{{TEI_NS}}}cb',
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

# Wortgrenzen: Leerzeichen, Satzzeichen, festes Leerzeichen
WORD_BOUNDARY_RE = re.compile(r'[\s\u00a0\u202f,\.;:!?\(\)\[\]{}\"\'\-–—/\\|]')

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
        elif tag == LANGES_S_TAG and child.get('rendition') == '#langesS':
            # Weiteres <c rendition="#langesS"> im gleichen Wort → Platzhalter (wird zu ſ)
            # Keinesfalls den Textinhalt 's' direkt einfügen – s ≠ ſ!
            parts.append(placeholder)
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


def get_word_around(elem):
    """
    Findet das vollständige Wort um ein <c rendition="#langesS">-Element.
    Traversiert aufwärts bis zum nächsten Block-Container und serialisiert
    dessen Textinhalt, um korrekte Wortgrenzen zu ermitteln.
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

    s_char = 'ſ'

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

    # Platzhalter aus before/after entfernen (weitere lange S im selben Wort)
    before_part = before_part.replace(placeholder, 'ſ')
    after_part = after_part.replace(placeholder, 'ſ')

    word = (before_part + s_char + after_part).lower()

    # Leerstring oder nur Satzzeichen ignorieren
    if not re.search(r'\w', word, re.UNICODE):
        return None

    return word


# ── Zweite Spalte: Normalform mit modernen s/ſ-Regeln ──────────────────────
# Regel: ſ am Wortanfang und in Wortmitte, s am Wortende und vor bestimmten
# Konsonanten (st, sp am Anfang zählen als s – historisch variabel,
# hier vereinfacht: ſ überall außer am Wortende und vor t/p nach Vokal
# ist eine komplexe Frage; wir geben hier nur die Basisregel aus).
# Da das eine editionswissenschaftliche Entscheidung ist, geben wir
# einfach das rekonstruierte Wort mit den tatsächlich codierten ſ aus,
# und ersetzen nur die ungekennzeichneten s durch s (Kleinbuchstabe).

# Die zweite Spalte wird im XML als @modern gesetzt.

def modern_form(word_with_langes_s):
    """
    Gibt das Wort zurück, wie es mit moderner s/ſ-Unterscheidung aussähe.
    Hier: ſ bleibt ſ (aus der Kodierung), normales s bleibt s.
    Das ist die korrekte Form – keine naive Ersetzung.
    """
    return word_with_langes_s  # bereits korrekt aus Kodierung


# ── Hauptprogramm ────────────────────────────────────────────────────────────

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
    # Spalte 1: Normalform – ſ → s
    w_el.text = word.replace('ſ', 's')
    # Spalte 2: Original mit ſ (wie kodiert)
    w_el.set('langesS', word)

tree_out = ET.ElementTree(root_el)
ET.indent(tree_out, space='  ')
os.makedirs('./data/meta', exist_ok=True)
tree_out.write('./data/meta/langes_s.xml', encoding='UTF-8', xml_declaration=True)
print(f"Fertig: {total} Vorkommen, {unique} einzigartige Wörter.")
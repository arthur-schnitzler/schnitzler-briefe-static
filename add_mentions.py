import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
indices = glob.glob('./data/indices/list*.xml')

# Für Entitäten, die im Haupttext erwähnt sind (tei:body ohne Kommentar)
d_text = defaultdict(set)
# Für Entitäten, die in Kommentaren erwähnt sind (tei:note[@type='commentary'])
d_commentary = defaultdict(set)
# Für Entitäten, die im Rückwärtstext (back) erscheinen (wird nicht mehr gesondert behandelt)
d_back = defaultdict(set)

for x in tqdm(sorted(files), total=len(files)):
    doc = TeiReader(x)
    file_name = os.path.split(x)[1]
    doc_title = doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')[0]
    doc_date = doc.any_xpath('.//tei:titleStmt/tei:title[@type="iso-date"]/@when-iso')
    doc_date = doc_date[0] if doc_date else ""

    # Entitäten aus <back> werden weiterhin gesammelt, aber nicht mehr im Index ausgegeben
    for entity in doc.any_xpath('.//tei:back//*[@xml:id]/@xml:id'):
        d_back[entity].add(f"{file_name}_____{doc_title}_____{doc_date}")

    # Entitäten, die im Haupttext erwähnt sind, aber nicht in Kommentaren
    for node in doc.any_xpath('.//tei:body//*[@xml:id][not(ancestor::tei:note[@type="commentary"])]'):
        entity_id = node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        d_text[entity_id].add(f"{file_name}_____{doc_title}_____{doc_date}")

    # Entitäten, die in Kommentaren erwähnt sind
    commentary_ref_targets = set()
    for ref_node in doc.any_xpath('.//tei:body//tei:note[@type="commentary"]//*[@ref or @target]'):
        targets = []
        if 'ref' in ref_node.attrib:
            targets.append(ref_node.attrib['ref'].lstrip('#'))
        if 'target' in ref_node.attrib:
            targets.append(ref_node.attrib['target'].lstrip('#'))
        for t in targets:
            d_commentary[t].add(f"{file_name}_____{doc_title}_____{doc_date}")

for x in indices:
    doc = TeiReader(x)
    for node in doc.any_xpath('.//tei:body//*[@xml:id]'):
        node_id = node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        # Nur noch Notizen erzeugen, wenn commentary oder text
        mentions = set.union(d_text.get(node_id, set()), d_commentary.get(node_id, set()))
        for mention in sorted(mentions):
            file_name, doc_title, doc_date = mention.split('_____')
            note = ET.Element('{http://www.tei-c.org/ns/1.0}note')
            note.attrib['target'] = file_name
            note.attrib['corresp'] = doc_date
            note.attrib['type'] = "mentions"

            if mention in d_commentary.get(node_id, set()) and mention not in d_text.get(node_id, set()):
                note.attrib['subtype'] = "commentary"
            elif mention in d_text.get(node_id, set()):
                note.attrib['subtype'] = "text"

            note.text = doc_title
            node.append(note)
    doc.tree_to_file(x)

print("DONE")

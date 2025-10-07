import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
indices = glob.glob('./data/indices/list*.xml')

d = defaultdict(set)
d_commentary = defaultdict(set)  # Separate tracking for commentary mentions

for x in tqdm(sorted(files), total=len(files)):
    doc = TeiReader(x)
    file_name = os.path.split(x)[1]
    doc_title = doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')[0]
    doc_date = doc.any_xpath('.//tei:titleStmt/tei:title[@type="iso-date"]/@when-iso')
    doc_date = doc_date[0] if doc_date else ""

    # Collect all entities from back
    for entity in doc.any_xpath('.//tei:back//*[@xml:id]/@xml:id'):
        d[entity].add(f"{file_name}_____{doc_title}_____{doc_date}")

    # Separately track entities mentioned in commentary notes
    # XPath: entities in back that are also referenced in body commentary notes
    for entity_node in doc.any_xpath('.//tei:back//*[@xml:id]'):
        entity_id = entity_node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        # Check if this entity is referenced in a commentary note
        # Look for refs with target/ref attributes pointing to this entity in commentary
        commentary_refs = doc.any_xpath(
            f'.//tei:body//tei:note[@type="commentary"]//*[@ref="#{entity_id}" or @target="#{entity_id}" or contains(@ref, "{entity_id}") or contains(@target, "{entity_id}")]'
        )
        if commentary_refs:
            d_commentary[entity_id].add(f"{file_name}_____{doc_title}_____{doc_date}")

for x in indices:
    print(x)
    doc = TeiReader(x)
    for node in doc.any_xpath('.//tei:body//*[@xml:id]'):
        node_id = node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        for mention in d[node_id]:
            file_name, doc_title, doc_date = mention.split('_____')
            note = ET.Element('{http://www.tei-c.org/ns/1.0}note')
            note.attrib['target'] = file_name
            note.attrib['corresp'] = doc_date
            note.attrib['type'] = "mentions"

            # Mark if this mention is from a commentary
            if mention in d_commentary[node_id]:
                note.attrib['subtype'] = "commentary"

            note.text = doc_title
            node.append(note)
    doc.tree_to_file(x)

print("DONE")

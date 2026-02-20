import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
indices = glob.glob('./data/indices/list*.xml')

d = defaultdict(set)
for x in tqdm(sorted(files), total=len(files)):
    doc = TeiReader(x)
    file_name = os.path.split(x)[1]
    doc_title = doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')[0]
    doc_date = doc.any_xpath('.//tei:titleStmt/tei:title[@type="iso-date"]/@when-iso')
    doc_date = doc_date[0] if doc_date else ""
    for entity_node in doc.any_xpath('.//tei:back//*[@xml:id]'):
        entity_id = entity_node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        ana_attr = entity_node.attrib.get('ana', '')
        d[entity_id].add(f"{file_name}_____{doc_title}_____{doc_date}_____{ana_attr}")

for x in indices:
    print(x)
    doc = TeiReader(x)
    for node in doc.any_xpath('.//tei:body//*[@xml:id]'):
        node_id = node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        for mention in d[node_id]:
            file_name, doc_title, doc_date, ana_attr = mention.split('_____')
            note = ET.Element('{http://www.tei-c.org/ns/1.0}note')
            note.attrib['target'] = file_name
            note.attrib['corresp'] = doc_date
            note.attrib['type'] = "mentions"
            if ana_attr == 'comment':
                note.attrib['ana'] = 'comment'
            note.text = doc_title
            node.append(note)
    doc.tree_to_file(x)

print("DONE")
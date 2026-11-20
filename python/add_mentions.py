import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
indices = glob.glob('./data/indices/list*.xml')

def corresp_place_category(doc, entity_id):
    """Kategorie eines Orts, der als Versand-/Empfangsort im correspDesc steht.

    Steht er auch im Brieftext, gilt er als normale Erwähnung (''), sonst
    'comment' bzw. 'implied', wenn er nur im Kommentar oder implizit vorkommt,
    und 'correspPlace', wenn er ausschließlich Versand-/Empfangsort ist.
    """
    in_commentary = False
    implied = False
    for elem in doc.any_xpath(
            './/tei:text//*[@ref][not(ancestor::tei:back)]'):
        tokens = {t.lstrip('#') for t in elem.attrib['ref'].split()}
        if entity_id not in tokens:
            continue
        if elem.xpath('ancestor::tei:note[@type="commentary" or @type="textConst"]',
                      namespaces={'tei': 'http://www.tei-c.org/ns/1.0'}):
            in_commentary = True
        elif elem.attrib.get('subtype') == 'implied':
            implied = True
        else:
            return ''
    if in_commentary:
        return 'comment'
    if implied:
        return 'implied'
    return 'correspPlace'


d = defaultdict(set)
for x in tqdm(sorted(files), total=len(files)):
    doc = TeiReader(x)
    file_name = os.path.split(x)[1]
    doc_title = doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')[0]
    doc_date = ""
    for attr in ["@when", "@from", "@notBefore", "@to", "@notAfter"]:
        result = doc.any_xpath(f'.//tei:correspDesc[1]/tei:correspAction[@type="sent"][1]/tei:date[1]/{attr}')
        if result:
            doc_date = result[0]
            break
    # Orte aus correspAction (Versand-/Empfangsort). Im <back> zählen sie als
    # Textnennung ohne @ana; hier wird geprüft, ob der Ort im Brief sonst vorkommt.
    corresp_place_ids = {
        token.lstrip('#')
        for ref in doc.any_xpath('.//tei:correspDesc//tei:placeName/@ref')
        for token in ref.split()
    }
    for entity_node in doc.any_xpath('.//tei:back//*[@xml:id]'):
        entity_id = entity_node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        ana_attr = entity_node.attrib.get('ana', '')
        if not ana_attr and entity_id in corresp_place_ids:
            ana_attr = corresp_place_category(doc, entity_id)
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
            if ana_attr in ('comment', 'implied', 'correspPlace'):
                note.attrib['ana'] = ana_attr
            note.text = doc_title
            node.append(note)
    doc.tree_to_file(x)

print("DONE")
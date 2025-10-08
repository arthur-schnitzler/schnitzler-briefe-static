import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_xml_pyutils.xml import NSMAP
from acdh_tei_pyutils.utils import (
    extract_fulltext,
    get_xmlid,
    make_entity_label,
    check_for_hash,
)
from tqdm import tqdm


def extract_fulltext_with_spacing(root_node, tag_blacklist=None):
    """
    Extract fulltext with proper spacing around block-level TEI elements.
    Adds spaces around elements like tei:p, tei:salute, tei:dateline, tei:closer, tei:seg.
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
            try:
                parent = element.getparent() if hasattr(element, 'getparent') else None
                if parent is not None:
                    parent_tag = parent.tag.split('}')[-1] if hasattr(parent.tag, 'split') else str(parent.tag).split('}')[-1]
                    if parent_tag == 'subst':
                        # Get all text content of this del element
                        if hasattr(element, 'itertext'):
                            del_text = ''.join(element.itertext())
                        else:
                            # Fallback for ElementTree
                            del_text = element.text or ''
                            for child in element:
                                if child.text:
                                    del_text += child.text
                                if child.tail:
                                    del_text += child.tail

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


files = glob.glob("./data/editions/*.xml")
COLLECTION_NAME = "schnitzler-briefe"
MIN_DATE = "1000"


try:
    client.collections[COLLECTION_NAME].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": COLLECTION_NAME,
    "enable_nested_fields": True,
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {
            "name": "editionstext",
            "type": "string",
            "optional": True,
        },
        {
            "name": "kommentar",
            "type": "string",
            "optional": True,
        },
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
        },
        {
            "name": "sender",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "receiver",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "persons",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "places",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "orgs",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "works",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "events",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "text_areas",
            "type": "string[]",
            "facet": True,
            "optional": True,
        },
    ],
}

client.collections.create(current_schema)

records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        "project": COLLECTION_NAME,
    }
    record = {}
    doc = TeiReader(x)
    body = doc.any_xpath(".//tei:body")[0]
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = (
        f"https://schnitzler-briefe.acdh.oeaw.ac.at/{record['id']}.html"
    )
    record["rec_id"] = os.path.split(x)[-1]
    cfts_record["rec_id"] = record["rec_id"]
    record["title"] = extract_fulltext(
        doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]')[0]
    )
    cfts_record["title"] = record["title"]
    try:
        date_str = doc.any_xpath(
            '//tei:titleStmt/tei:title[@type="iso-date"]/@when-iso'
        )[0]
    except IndexError:
        date_str = MIN_DATE

    record["sender"] = []
    try:
        sender_label = doc.any_xpath(
            './/tei:correspAction[@type="sent"]/tei:persName/text()'
        )[0]
        sender_id = check_for_hash(
            doc.any_xpath('.//tei:correspAction[@type="sent"]/tei:persName/@ref')[0]
        )
    except Exception as e:
        print(f"sender issues in {x}, due to: {e}")
        sender_label = "Kein Absender"
        sender_id = None
    record["sender"].append({"label": sender_label, "id": sender_id})
    record["receiver"] = []
    try:
        receiver_label = doc.any_xpath(
            './/tei:correspAction[@type="received"]/tei:persName/text()'
        )[0]
        receiver_id = check_for_hash(
            doc.any_xpath('.//tei:correspAction[@type="received"]/tei:persName/@ref')[0]
        )
    except Exception as e:
        print(f"receiver issues in {x}, due to: {e}")
        receiver_label = "Kein Absender"
        receiver_id = None
    record["receiver"].append({"label": receiver_label, "id": receiver_id})

    try:
        record["year"] = int(date_str[:4])
        cfts_record["year"] = int(date_str[:4])
    except ValueError:
        pass
    record["persons"] = []
    for y in doc.any_xpath(".//tei:back//tei:person[@xml:id]"):
        item = {"id": get_xmlid(y), "label": make_entity_label(y.xpath("./*[1]")[0])[0]}
        record["persons"].append(item)
    cfts_record["persons"] = [x["label"] for x in record["persons"]]

    record["places"] = []
    for y in doc.any_xpath(".//tei:back//tei:place[@xml:id]"):
        item = {"id": get_xmlid(y), "label": make_entity_label(y.xpath("./*[1]")[0])[0]}
        record["places"].append(item)
    cfts_record["places"] = [x["label"] for x in record["places"]]

    record["orgs"] = []
    for y in doc.any_xpath(".//tei:back//tei:org[@xml:id]"):
        item = {"id": get_xmlid(y), "label": make_entity_label(y.xpath("./*[1]")[0])[0]}
        record["orgs"].append(item)

    record["works"] = []
    for y in doc.any_xpath(".//tei:back//tei:bibl[@xml:id]"):
        item = {"id": get_xmlid(y), "label": make_entity_label(y.xpath("./*[1]")[0])[0]}
        record["works"].append(item)

    record["events"] = []
    for y in doc.any_xpath(".//tei:back//tei:event[@xml:id]"):
        event_name = y.xpath(".//tei:eventName/text()", namespaces=NSMAP)[0] if y.xpath(".//tei:eventName/text()", namespaces=NSMAP) else "Unbekanntes Ereignis"
        event_type = y.xpath(".//tei:eventName/@n", namespaces=NSMAP)[0] if y.xpath(".//tei:eventName/@n", namespaces=NSMAP) else None

        item = {
            "id": get_xmlid(y),
            "label": event_name,
            "type": event_type
        }
        record["events"].append(item)

    cfts_record["places"] = [x["label"] for x in record["places"]]
    record["full_text"] = f"{extract_fulltext_with_spacing(body)} {record['title']}".replace("(", " ")
    cfts_record["full_text"] = record["full_text"]

    # Extract separate text for each area
    text_areas = []

    # Editionstext: body text excluding commentary notes
    editionstext_elements = doc.any_xpath(
        ".//tei:body//*[not(self::tei:note[@type='commentary']) and not(ancestor::tei:note[@type='commentary'])]"
    )
    if editionstext_elements:
        editionstext = extract_fulltext_with_spacing(body)
        # Remove commentary text from editionstext
        for commentary in doc.any_xpath(".//tei:body//tei:note[@type='commentary']"):
            commentary_text = extract_fulltext_with_spacing(commentary)
            editionstext = editionstext.replace(commentary_text, " ")
        editionstext = editionstext.strip()
        if editionstext:
            record["editionstext"] = editionstext.replace("(", " ")
            text_areas.append("Editionstext")

    # Kommentar: commentary notes in body
    kommentar_elements = doc.any_xpath(".//tei:body//tei:note[@type='commentary']")
    if kommentar_elements:
        kommentar_texts = [extract_fulltext_with_spacing(elem) for elem in kommentar_elements]
        kommentar = " ".join(kommentar_texts).strip()
        if kommentar:
            record["kommentar"] = kommentar.replace("(", " ")
            text_areas.append("Kommentar")

    record["text_areas"] = text_areas

    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"done with indexing {COLLECTION_NAME}")

make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print(f"done with cfts-index {COLLECTION_NAME}")

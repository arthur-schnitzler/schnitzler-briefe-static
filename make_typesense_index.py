import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import (
    extract_fulltext,
    get_xmlid,
    make_entity_label,
    check_for_hash,
)
from tqdm import tqdm


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
    cfts_record["places"] = [x["label"] for x in record["places"]]
    record["full_text"] = f"{extract_fulltext(body)} {record['title']}"
    cfts_record["full_text"] = record["full_text"]
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"done with indexing {COLLECTION_NAME}")

# make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
# print(make_index)
# print(f"done with cfts-index {COLLECTION_NAME}")

import glob
import os
import shutil
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import normalize_string, make_entity_label, nsmap
from rdflib import Graph, Namespace, URIRef, RDF, Literal, XSD
from tqdm import tqdm

g = Graph().parse("arche/arche_constants.ttl")
ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")
G_REPO_OBJECTS = Graph().parse("arche/repo_objects_constants.ttl")
ID = Namespace("https://id.acdh.oeaw.ac.at/schnitzler/schnitzler-briefe")
TO_INGEST = "to_ingest"

shutil.rmtree(TO_INGEST, ignore_errors=True)
os.makedirs(TO_INGEST, exist_ok=True)
shutil.copy("html/img/title-img.jpg", "to_ingest/title-img.jpg")

print("processing data/indices")
files = glob.glob("data/indices/*.xml")
for x in tqdm(files, total=len(files)):
    if "siglen" in x:
        continue
    else:
        fname = os.path.split(x)[-1]
        # don't copy index files due to: https://github.com/acdh-oeaw/arche-core/issues/39 
        # shutil.copyfile(x, os.path.join(TO_INGEST, fname))
        doc = TeiReader(x)
        uri = URIRef(f"{ID}/indices/{fname}")
        g.add((uri, RDF.type, ACDH["Resource"]))
        g.add((uri, ACDH["isPartOf"], URIRef(f"{ID}/indices"))) 
        g.add((uri, ACDH["hasIdentifier"], URIRef(f"{ID}/{fname}")))
        g.add((uri, ACDH["hasCategory"], URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei")))
        try:
            has_title = normalize_string(doc.any_xpath(".//tei:titleStmt[1]/tei:title[@level='a']/text()")[0])
        except IndexError:
            has_title = normalize_string(doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]/text()")[0])
        g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="de")))


print("processing data/editions")
files = glob.glob("data/editions/*.xml")
files = files[:5]
for x in tqdm(files, total=len(files)):
    fname = os.path.split(x)[-1]
    shutil.copyfile(x, os.path.join(TO_INGEST, fname))
    doc = TeiReader(x)
    uri = URIRef(f"{ID}/editions/{fname}")
    g.add((uri, RDF.type, ACDH["Resource"]))
    g.add((uri, ACDH["isPartOf"], URIRef(f"{ID}/editions")))
    g.add((uri, ACDH["hasIdentifier"], URIRef(f"{ID}/{fname}")))
    g.add((uri, ACDH["hasCategory"], URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei")))
    try:
        has_title = normalize_string(doc.any_xpath(".//tei:titleStmt[1]/tei:title[@level='a']/text()")[0])
    except IndexError:
        has_title = normalize_string(doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]/text()")[0])
    g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="de")))

    # try:
    #     start_date = doc.any_xpath(".//tei:titleStmt[1]/tei:title[@type='iso-date']")[0]
    # except IndexError:
    #     start_date = False
    # if start_date:
    #     print(start_date)
    #     g.add((uri, ACDH["hasCreatedStartDateOriginal"]), Literal(start_date.text, datatype=XSD.date))
    #     g.add((uri, ACDH["hasCreatedEndDateOriginal"]), Literal(start_date.text, datatype=XSD.date))

    for y in doc.any_xpath(".//tei:back//tei:person[./tei:idno[@subtype='d-nb']]"):
        person_uri = URIRef(f'{y.xpath("./tei:idno[@subtype='d-nb']/text()", namespaces=nsmap)[0]}')
        has_title = make_entity_label(y.xpath("./*[1]", namespaces=nsmap)[0], default_lang="de")
        g.add((uri, ACDH["hasActor"], person_uri))
        g.add((person_uri, RDF.type, ACDH["Person"]))
        g.add((person_uri, ACDH["hasTitle"], Literal(has_title[0], lang=has_title[1])))

    for y in doc.any_xpath(".//tei:back//tei:place[./tei:idno[@subtype='geonames']]"):
        place_uri = URIRef(f'{y.xpath("./tei:idno[@subtype='geonames']/text()", namespaces=nsmap)[0]}')
        has_title = make_entity_label(y.xpath("./*[1]", namespaces=nsmap)[0], default_lang="de")
        g.add((uri, ACDH["hasSpatialCoverage"], place_uri))
        g.add((place_uri, RDF.type, ACDH["Place"]))
        g.add((place_uri, ACDH["hasTitle"], Literal(has_title[0], lang=has_title[1])))

print("adding repo objects constants now")
COLS = [ACDH["TopCollection"], ACDH["Collection"], ACDH["Resource"]]
COL_URIS = set()
for x in COLS:
    for s in g.subjects(None, x):
        COL_URIS.add(s)
for x in COL_URIS:
    for p, o in G_REPO_OBJECTS.predicate_objects():
        g.add((x, p, o))

g.parse("arche/title_image.ttl")
g.serialize(os.path.join(TO_INGEST, "arche.ttl"))

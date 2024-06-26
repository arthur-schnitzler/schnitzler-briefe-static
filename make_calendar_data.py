import glob
import os
import json
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


out_path = os.path.join("html", "js-data")
os.makedirs(out_path, exist_ok=True)

files = sorted(glob.glob("./data/editions/*.xml"))

out_file = os.path.join(out_path, "calendarData.js")
data = []
for x in tqdm(files, total=len(files)):
    item = {}
    head, tail = os.path.split(x)
    doc = TeiReader(x)
    item["name"] = doc.any_xpath('//tei:title[@level="a"]/text()')[0]
    try:
        item["startDate"] = doc.any_xpath('//tei:title[@type="iso-date"]/text()')[0]
    except IndexError:
        continue
    try:
        item["tageszaehler"] = doc.any_xpath('//tei:title[@type="iso-date"]/@n')[0]
        item["id"] = tail.replace(".xml", ".html")
        data.append(item)
    except IndexError:
        continue

print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)}"
    f.write(my_js_variable)

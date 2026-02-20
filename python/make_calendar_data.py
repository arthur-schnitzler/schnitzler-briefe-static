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
        
        # Determine letter category using the same XPATH logic as XSLT
        # Check if Schnitzler is sender (pmb2121 is Schnitzler's ID)
        is_schnitzler_sender = doc.any_xpath('//tei:correspAction[@type="sent"]//tei:persName[@ref="#pmb2121"]')
        is_schnitzler_receiver = doc.any_xpath('//tei:correspAction[@type="received"]//tei:persName[@ref="#pmb2121"]')
        
        if is_schnitzler_sender:
            item["category"] = "as-sender"  # FROM Schnitzler
            item["categoryLabel"] = "Brief von Schnitzler"  # Accessible label
        elif is_schnitzler_receiver:
            item["category"] = "as-empf"    # TO Schnitzler
            item["categoryLabel"] = "Brief an Schnitzler"   # Accessible label
        else:
            item["category"] = "umfeld"     # Third party correspondence
            item["categoryLabel"] = "Umfeldbrief"           # Accessible label
        
        # Add accessibility metadata
        try:
            # Extract sender and receiver for screen readers
            sender = doc.any_xpath('//tei:correspAction[@type="sent"]//tei:persName/text()')
            receiver = doc.any_xpath('//tei:correspAction[@type="received"]//tei:persName/text()')
            if sender and receiver:
                item["accessible_desc"] = f"Brief von {sender[0]} an {receiver[0]}"
            elif sender:
                item["accessible_desc"] = f"Brief von {sender[0]}"
            elif receiver:
                item["accessible_desc"] = f"Brief an {receiver[0]}"
            else:
                item["accessible_desc"] = item["name"]
        except:
            item["accessible_desc"] = item["name"]
            
        data.append(item)
    except IndexError:
        continue

print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)}"
    f.write(my_js_variable)

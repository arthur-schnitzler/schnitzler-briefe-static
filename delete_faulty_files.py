import glob
import os
import csv
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


faulty_file_name = "./html/faulty.csv"
faulty = []
files = sorted(glob.glob("./data/*/*.xml"))
print(f"check {len(files)} files and delete not well formed ones")

for x in tqdm(files, total=len(files)):
    _, tail = os.path.split(x)
    try:
        doc = TeiReader(x)
    except Exception as e:
        faulty.append([tail, e])
        os.remove(x)

if len(faulty) > 0:
    print(f"writing report to '{faulty_file_name}'")
else:
    print(f"no faulty files found, good job!!!!")
    faulty.append(["no faulty files found", "good job!"])
with open(faulty_file_name, "w", newline="") as csvfile:
    my_writer = csv.writer(csvfile, delimiter=",")
    my_writer.writerow(["path", "error"])
    for x in faulty:
        my_writer.writerow([x[0], x[1]])

# bin/bash

# get schnitzler-briefe-data

rm -rf data
wget https://github.com/arthur-schnitzler/schnitzler-briefe-data/archive/refs/heads/main.zip
unzip main

mv ./schnitzler-briefe-data-main/data .
rm -rf ./data/xslts
rm main.zip
rm -rf ./schnitzler-briefe-data-main

# get schnitzler-chronik-data

# Download XML files from GitHub repository
wget https://github.com/arthur-schnitzler/schnitzler-chronik-data/archive/refs/heads/main.zip
rm -rf chronik-data
unzip main.zip

mv schnitzler-chronik-data-main/editions/data chronik-data/
rm -rf schnitzler-chronik-data-main

rm main.zip



# echo "delete schema reference"
find ./data/editions/ -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@xsi:schemaLocation="http://www.tei-c.org/ns/1.0 ../meta/asbwschema.xsd"@@g'

# echo "fixing entity ids"
find ./data/indices/ -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<person xml:id="person__@<person xml:id="pmb@g'

# get schnitzler-briefe-tex

rm -rf .html/L*.pdf
wget https://github.com/arthur-schnitzler/schnitzler-briefe-tex/archive/refs/heads/main.zip
unzip main

mv ./schnitzler-briefe-tex-main/pdf-leseansicht/L*.pdf ./html
rm main.zip
rm -rf ./schnitzler-briefe-tex-main

# get schnitzler-briefe-networks

wget https://github.com/arthur-schnitzler/schnitzler-briefe-networks/archive/refs/heads/main.zip
rm -rf network-data
unzip main.zip

mkdir network-data

mv schnitzler-briefe-networks-main/*/*.csv network-data/
rm -rf schnitzler-briefe-networks-main

rm main.zip

CSV_DIR="network-data"
for CSV_FILE in $CSV_DIR/*.csv
do
  BASE_NAME=$(basename "$CSV_FILE" .csv)
  XML_FILE="$CSV_DIR/$BASE_NAME.xml"
  echo "<root></root>" > "$XML_FILE"
done

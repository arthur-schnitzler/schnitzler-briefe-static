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
rm -rf chronik-data
mkdir -p chronik-data
git clone --depth 1 --filter=blob:none --sparse https://github.com/arthur-schnitzler/schnitzler-chronik-data.git temp-chronik
cd temp-chronik
git sparse-checkout set editions/data
cd ..
find temp-chronik/editions/data -name "*.xml" -exec cp {} chronik-data/ \;
rm -rf temp-chronik



# echo "delete schema reference"
find ./data/editions/ -type f -name "*.xml"  -print0 | xargs -0 sed -i '' -e 's@xsi:schemaLocation="http://www.tei-c.org/ns/1.0 ../meta/asbwschema.xsd"@@g'

# echo "fixing entity ids"
find ./data/indices/ -type f -name "*.xml"  -print0 | xargs -0 sed -i '' -e 's@<person xml:id="person__@<person xml:id="pmb@g'

# get schnitzler-briefe-tex

rm -rf ./html/L*.pdf
mkdir -p ./html
git clone --depth 1 --filter=blob:none --sparse https://github.com/arthur-schnitzler/schnitzler-briefe-tex.git temp-tex
cd temp-tex
git sparse-checkout set pdf-leseansicht
cd ..
find temp-tex/pdf-leseansicht -name "*.pdf" -exec cp {} ./html/ \;
rm -rf temp-tex

# get schnitzler-briefe-charts

wget https://github.com/arthur-schnitzler/schnitzler-briefe-charts/archive/refs/heads/main.zip
rm -rf network-data
unzip main.zip

mkdir network-data

mv schnitzler-briefe-charts-main/netzwerke/*/*corr_weights_directed*.csv network-data/

# Fetch index statistics from charts repo
echo "Fetching index statistics..."
mkdir -p html/js-data
cp schnitzler-briefe-charts-main/statistiken/allgemeiner-text/gesamtstatistik.json html/js-data/
cp schnitzler-briefe-charts-main/statistiken/allgemeiner-text/viz*.json html/js-data/

rm -rf schnitzler-briefe-charts-main

rm main.zip

CSV_DIR="network-data"
for CSV_FILE in $CSV_DIR/*.csv
do
  BASE_NAME=$(basename "$CSV_FILE" .csv)
  XML_FILE="$CSV_DIR/$BASE_NAME.xml"
  echo "<root></root>" > "$XML_FILE"
done
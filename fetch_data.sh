# bin/bash

rm -rf data
wget https://github.com/arthur-schnitzler/schnitzler-briefe-data/archive/refs/heads/main.zip
unzip main

mv ./schnitzler-briefe-data-main/data .
rm -rf ./data/xslts
rm main.zip
rm -rf ./schnitzler-briefe-data-main

echo "delete schema reference"
find ./data/editions/ -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@xsi:schemaLocation="http://www.tei-c.org/ns/1.0 ../meta/asbwschema.xsd"@@g'

echo "fixing entity ids"
find ./data/indices/ -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<person xml:id="person__@<person xml:id="pmb@g'

rm -rf data
wget https://github.com/arthur-schnitzler/schnitzler-briefe-tex/archive/refs/heads/main.zip
unzip main

mv ./schnitzler-briefe-tex-main/pdf-leseansicht .
rm main.zip
rm -rf ./schnitzler-briefe-tex-main

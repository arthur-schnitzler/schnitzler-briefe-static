#!/bin/bash

echo "check and delete faulty files"
python3 delete_faulty_files.py

echo "add mentions"
python3 add_mentions.py

echo "make calendar data"
python3 make_calendar_data.py

echo "generate letter statistics"
python3 generate_letter_statistics.py

echo "fetch and integrate CMIF printed letters data"
python3 fetch_cmif_data.py

echo "build ft-index"
python3 make_typesense_index.py

python3 oai-pmh/make_files.py

echo "generate SEO metadata and analysis"
python3 generate_seo_metadata.py

echo "create app"
ant

echo "generate sitemap and robots.txt"
python3 generate_sitemap.py

echo "running final SEO build and validation"
python3 seo_build.py

echo "SEO optimization completed - all files generated and validated"
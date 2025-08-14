#!/bin/bash

echo "check and delete faulty files"
python delete_faulty_files.py

echo "add mentions"
python add_mentions.py

echo "make calendar data"
python make_calendar_data.py

echo "fetch and integrate CMIF printed letters data"
python fetch_cmif_data.py

echo "build ft-index"
python make_typesense_index.py

python oai-pmh/make_files.py

echo "generate SEO metadata and analysis"
python generate_seo_metadata.py

echo "create app"
ant

echo "generate sitemap and robots.txt"
python generate_sitemap.py

echo "running final SEO build and validation"
python seo_build.py

echo "SEO optimization completed - all files generated and validated"
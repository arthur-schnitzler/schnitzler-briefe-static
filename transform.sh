#!/bin/bash

# Exit immediately if any command fails
set -e

echo "check and delete faulty files"
python3 python/delete_faulty_files.py

echo "update params.xsl with current statistics"
python3 python/update_params.py

echo "add mentions"
python3 python/add_mentions.py

echo "make calendar data"
python3 python/make_calendar_data.py

echo "generate letter statistics"
python3 python/generate_letter_statistics.py

echo "generate langes-s word statistics"
python3 python/make_langes_s_stats.py

echo "fetch and integrate CMIF printed letters data"
python3 python/fetch_cmif_data.py

echo "build ft-index"
python3 python/make_typesense_index.py

python3 oai-pmh/make_files.py

echo "generate SEO metadata and analysis"
python3 python/generate_seo_metadata.py

echo "create app"
ant

echo "generate sitemap and robots.txt"
python3 python/generate_sitemap.py

echo "running final SEO build and validation"
python3 python/seo_build.py

echo "SEO optimization completed - all files generated and validated"
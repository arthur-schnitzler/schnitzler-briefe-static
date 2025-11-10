#!/bin/bash

# hacky way to make shure the script
# gets allways run from parent-dir
# so relative paths get resolved the righ way
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir/.."
# run scripts
./shellscripts/dl_imprint.sh
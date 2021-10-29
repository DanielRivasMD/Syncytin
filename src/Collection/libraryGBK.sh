#!/bin/bash
set -euo pipefail

################################################################################

# download protein accessions
echo 'Download protein accessions...'

cd "${databaseDir}/genBank"

# use ncbi download
ncbi-acc-download \
  --verbose \
  --format genbank \
  $(cat "${accNDir}/"*)

cd - > /dev/null

################################################################################

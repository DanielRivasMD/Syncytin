#!/bin/bash
set -euo pipefail

################################################################################

# download protein accessions
echo 'Download protein accessions...'

cd ${syncDB}/genBank

ncbi-acc-download \
  --verbose \
  --format genbank \
  $(cat ${accNDir}/*)

cd - > /dev/null

################################################################################

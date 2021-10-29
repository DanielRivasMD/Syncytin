#!/bin/bash
set -euo pipefail

################################################################################

cd ${projDir}

# use ncbi download
ncbi-acc-download \
  --verbose \
  --molecule protein \
  --format fasta \
  --out "${databaseDir}/protein/syncytinLibrary.fasta" \
  $(cat "${accPDir}/"*)

cd - > /dev/null

################################################################################

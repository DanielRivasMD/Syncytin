#!/bin/bash
set -euo pipefail

################################################################################

cd "${projDir}"

# use ncbi download
ncbi-acc-download \
  --verbose \
  --molecule nucleotide \
  --format fasta \
  --out "${databaseDir}/nucleotide/syncytinLibrary.fasta" \
  $(cat "${accNDir}/"*)

cd - > /dev/null

################################################################################

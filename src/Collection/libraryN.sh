#!/bin/bash
set -euo pipefail

################################################################################

cd ${projDir}

ncbi-acc-download \
  --verbose \
  --molecule nucleotide \
  --format fasta \
  --out ${syncDB}/nucleotide/syncytinLibrary.fasta \
  $(cat ${accNDir}/*)

cd - > /dev/null

################################################################################

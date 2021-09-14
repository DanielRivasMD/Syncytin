#!/bin/bash

################################################################################

cd ${syncProj}

ncbi-acc-download \
  --verbose \
  --molecule protein \
  --format fasta \
  --out ${syncDB}/protein/syncytinLibrary.fasta \
  $(cat ${accPDir}/*)

cd - > /dev/null

################################################################################

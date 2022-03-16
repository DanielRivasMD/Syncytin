#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# nucleotide
echo 'Colleting nucleotide accessions...'
source "${collectionDir}/libraryN.sh"

# genbank
echo 'Colleting GenBank records...'
source "${collectionDir}/libraryGBK.sh"

################################################################################

# TODO: update executable call
# check for Go executable
if [[ ! -x "${excalibur}/proteinAcc" ]]
then
  echo 'Building Go executable...'
  go build -o "${excalibur}/" "${collectionDir}/proteinAcc.go"
fi

# extract protein accessions
echo 'Writting protein accessions...'

for art in $( command ls "${accNDir}" );
do
  if [[ -f "${accPDir}/${art}" ]]
  then
    rm "${accPDir}/${art}"
  fi
  while read genRecord
  do
    "${excalibur}/proteinAcc" "${genBankDir}/${genRecord}.gbk" "${accPDir}/${art}"
  done < "${accNDir}/${art}"
done

################################################################################

# protein
echo 'Colleting protein accessions...'
source "${collectionDir}/libraryP.sh"

################################################################################

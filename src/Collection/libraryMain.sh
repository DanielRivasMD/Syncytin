#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# nucleotide
echo "Colleting nucleotide accessions..."
source ${collector}/libraryN.sh

# genbank
echo "Colleting GenBank records..."
source ${collector}/libraryGBK.sh

################################################################################

# TODO: update executable call
# check for Go executable
if [[ ! -x ${excalibur}/proteinAcc ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${collector}/proteinAcc.go
fi

# extract protein accessions
echo "Writting protein accessions..."

for art in $( $(which exa) ${accNDir} );
do
  if [[ -f ${accPDir}/${art} ]]
  then
    echo "Cleaning ${art}"
    rm ${accPDir}/${art}
  fi
  while read genRecord
  do
    ${excalibur}/proteinAcc ${genBank}/${genRecord}.gbk ${accPDir}/${art}
  done < ${accNDir}/${art}
done

################################################################################

# protein
echo "Colleting protein accessions..."
source ${collector}/libraryP.sh

################################################################################

#!/bin/bash

################################################################################

syncProj=$HOME/Factorem/Syncytin
collector=${syncProj}/src/collector
excalibur=${syncProj}/src/excalibur
syncDB=${syncProj}/data/syncytinDB
accNDir=${syncDB}/accessionN
accPDir=${syncDB}/accessionP
genBank=${syncDB}/genBank

################################################################################

# nucleotide
echo "Colleting nucleotide accessions..."
source ${collector}/libraryN.sh

# genbank
echo "Colleting GenBank records..."
source ${collector}/libraryGBK.sh

################################################################################

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

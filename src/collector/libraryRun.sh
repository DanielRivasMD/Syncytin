#!/bin/bash

################################################################################

syncProj=$HOME/Factorem/Syncytin
collector=${syncProj}/src/collector
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
    awk -f ${collector}/proteinAcc.awk ${genBank}/${genRecord}.gbk >> ${accPDir}/${art}
  done < ${accNDir}/${art}
done

################################################################################

# protein
echo "Colleting protein accessions..."
source ${collector}/libraryP.sh

################################################################################

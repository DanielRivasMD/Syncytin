#!/bin/bash

################################################################################

syncProj=$HOME/Factorem/Syncytin
collector=${syncProj}/src/collector
syncDB=${syncProj}/data/syncytinDB
accNDir=${syncDB}/accessionN
accPDir=${syncDB}/accessionP
genBank=${syncDB}/genBank

################################################################################

# extract protein accessions
echo "Collecting protein accessions..."
for art in $( ls ${accNDir} );
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

cd ${syncProj}

ncbi-acc-download \
  --verbose \
  --molecule protein \
  --format fasta \
  --out ${syncDB}/proteing/syncytinLibrary.fasta \
  $(cat ${accPDir}/*)

cd - > /dev/null

################################################################################

#!/bin/bash

################################################################################

cd $HOME/Factorem/Syncytin/data/DNAzoo/

while read name assembly annotation
do
  if [[ ! -f ${assembly} ]]
  then
    wget https://dnazoo.s3.wasabisys.com/${name}/${assembly}
    wget https://dnazoo.s3.wasabisys.com/${name}/${annotation}
  fi
done < <(awk 'BEGIN{FS = ","; OFS = " "} $2 ~/HiC/ && $3 !~/NA/ {for (ix = 1; ix <= NF; ix++) {printf $ix} printf "\n" }' $HOME/Factorem/Syncytin/data/assembly.list) # target HiC assemblies with available annotation

cd - > /dev/null

################################################################################

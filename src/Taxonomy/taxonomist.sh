#!/bin/bash

################################################################################

# declarations
projDir=${HOME}/Factorem/Syncytin
dataDir=${projDir}/data
taxonomist=${dataDir}/taxonomist
phylogeny=${dataDir}/phylogeny
diamond=${dataDir}/diamondOutput
taxGroups=(kingdom phylum class order family genus)

################################################################################

while read id ass ann
do

  # create directory
  dir=${taxonomist}/${id}
  mkdir -p ${dir}

  # collect taxonomy
  #echo ${id//_/ }
  ncbi-taxonomist collect --names ${id//_/ } --xml > ${dir}/${id}_taxonomist.xml

  # decompose taxonomy
  for tx in "${taxGroups[@]}"
  do
    grep -w $tx ${dir}/${id}_taxonomist.xml > ${dir}/${id}_${tx}.xml
  done

done < ${phylogeny}/CURATEDassembly.list

################################################################################

#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# taxonomy
taxGroups=(kingdom phylum class order family genus)

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

done < ${assemblyList}

################################################################################

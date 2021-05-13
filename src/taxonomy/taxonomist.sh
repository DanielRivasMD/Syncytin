#!/bin/bash

################################################################################

taxGroups=(kingdom phylum class order family genus)

################################################################################

while read id ass ann
do

  # create directory
  dir="/Users/drivas/Factorem/Syncytin/data/diamondOutput/${id}/taxonomist"
  mkdir -p ${dir}

  # collect taxonomy
  #echo ${id//_/ }
  ncbi-taxonomist collect --names ${id//_/ } --xml > ${dir}/${id}_taxonomist.xml

  # decompose taxonomy
  for tx in "${taxGroups[@]}"
  do
    #echo $tx
    grep -w $tx ${dir}/${id}_taxonomist.xml > ${dir}/${id}_${tx}.xml
  done

done < data/CURATEDassembly.list
#done <<< `awk 'NR == 1 {print $0}' data/CURATEDassembly.list`


################################################################################


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
done < $HOME/Factorem/Syncytin/data/phylogeny/CURATEDassembly.list # target HiC assemblies with available annotation

cd - > /dev/null

################################################################################

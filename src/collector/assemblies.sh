#!/bin/bash

################################################################################

cd $HOME/Factorem/Syncytin/data/DNAzoo/

while read assembly
do
  if [[ ! -f ${assembly} ]]
  then
    wget https://dnazoo.s3.wasabisys.com/${assembly/.fasta/}/${assembly/.fasta/}_HiC.fasta.gz
    gzip -d ${assembly}.gz
  fi
done < $HOME/Factorem/Syncytin/data/assembly.list

################################################################################

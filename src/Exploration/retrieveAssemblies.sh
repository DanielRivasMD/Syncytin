#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# download function
function download() {
  # go to download directory
  cd $1
  # download if not exist
  if [[ ! -f $2 ]]
  then
    wget $2
  fi
  # rename
  mv README.json $3.json
}

################################################################################

# record directory
originalDir=$(pwd)

# read filtered assembly list
while IFS=, read -r assemblySpp readmeLink assemblyLink annotationLink
do

  download ${assembly} ${readmeLink} ${assemblySpp} # README.json
  download ${DNAzoo} ${assemblyLink}                # HiC.fasta.gz
  download ${annotation} ${annotationLink}          # gff3.gz

done < ${wasabi}/filter/assemblyList.csv

# return to directory
cd ${originalDir}

################################################################################

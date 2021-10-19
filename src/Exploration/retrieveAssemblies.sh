#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# download function
function download() {
  # go to download directory
  cd $1
  # prevent readme collisions
  if [[ ! -z "$3" ]]
  then
    mkdir $3
    cd $3
  fi
  # download if not exist
  if [[ ! -f $2 ]]
  then
    wget $2
  fi
  # rename
  if [[ ! -z "$3" ]]
  then
    mv README.json ../$3.json
    cd ..
    rmdir $3
  fi
}

################################################################################

# check for command line argument
if [[ $# -eq 0 ]]
then
  echo "Error: download directory must be provided as an input argument."
  exit 1
fi

################################################################################

# record directory
originalDir=$(pwd)

# read filtered assembly list
while IFS=, read -r assemblySpp readmeLink assemblyLink annotationLink
do
  download ${assembly} ${readmeLink} ${assemblySpp} # README.json
  download ${DNAzoo} ${assemblyLink} ""             # HiC.fasta.gz
  download ${annotation} ${annotationLink} ""       # gff3.gz
done <<< $1

# return to directory
cd ${originalDir}

################################################################################

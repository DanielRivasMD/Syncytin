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

# iterate on selected assemblies
for spp in $( $( which exa) ${wasabi}/filter )
do

  while IFS=, read -r readmeLink assemblyLink annotationLink
  do

    download ${assembly} ${readmeLink} ${spp/.csv/}
    download ${DNAzoo} ${assemblyLink}
    download ${annotation} ${annotationLink}

  done < ${wasabi}/filter/${spp}
done

# return to directory
cd ${originalDir}

################################################################################

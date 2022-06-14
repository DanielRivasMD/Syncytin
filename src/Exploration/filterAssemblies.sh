#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# avoid appending
if [[ -f "${listDir}/DNAzooList.csv" ]]
then
  rm "${listDir}/DNAzooList.csv"
fi

# filter
for assembly in $( command ls "${wasabiDir}/raw" )
do

  if [[ "${assembly}" != "Mesocricetus_auratus__golden_hamster_wtdbg2.shortReadsPolished.csv" ]]
  then

    bender assembly filter --inDir "${wasabiDir}/raw/" --species "${assembly}" >> "${listDir}/DNAzooList.csv"

  fi

done

####################################################################################################

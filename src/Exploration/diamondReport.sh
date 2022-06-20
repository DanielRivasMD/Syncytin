#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# iterate on performance reports
for e in $(command ls "${reportDir}/"Performance*err)
do
  # collect information
  m=$(grep -w "slurmstepd: error: Detected 1" ${e})

  # test
  if [[ ! -n "$m" ]]
  then
    echo $e
  fi
done

####################################################################################################

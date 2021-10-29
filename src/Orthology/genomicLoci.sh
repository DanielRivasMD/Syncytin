#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# iterate on diamond output items
for align in $( $(which exa) "${diamondDir}/raw" )
do
  bender assembly loci --inDir "${diamondDir}/raw" --outDir "${diamondDir}/filter" --species "${align}"
done

################################################################################

#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# iterate on diamond output items
for align in $( $(which exa) "${diamond}/raw" )
do
  bender assembly loci --inDir "${diamond}/raw/${align}" --outDir "${diamond}/filter" --species "${align}.tsv"
done

################################################################################

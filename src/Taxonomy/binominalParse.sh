#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# iterate on binominal files
for b in $( $(which exa) "${phylogenyDir}/"*Binominal.csv )
do
  echo "${b/*\//}"
  awk 'BEGIN{FS = ","} {print $1, $2}' "${b}" > "${b/.csv/.txt}"
done

################################################################################

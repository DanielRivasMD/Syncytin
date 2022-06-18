#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# iterate on binominal files
for b in $(command ls "${phylogenyDir}/"*Binominal.csv)
do
  echo "${b/*\//}"
  awk 'BEGIN{FS = ","} { if (NR > 1) {print $1}}' "${b}" > "${b/.csv/.txt}"
done

####################################################################################################

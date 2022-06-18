#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# declarations
# inFile="Vulpes_vulpes.json"
inDir="/Users/drivas/Factorem/Syncytin/data/assembly"
outFile="assembly.csv"
outDir="data/stats"

################################################################################

# do not append
if [[ -f "${outDir}/${outFile}" ]]
then
  rm "${outDir}/${outFile}"
fi

################################################################################

# headers
echo "Species,Vernacular,Karyotype,ScaffoldN50,NumberScaffolds" > "${outDir}/${outFile}"

################################################################################

# TODO: update function call
# iterate over species
for spp in $(command ls "${inDir}")
do
  bender Assembly Description \
    -s "${spp}" \
    -I "${inDir}" \
    -o "${outFile}" \
    -O "${outDir}"
done

################################################################################

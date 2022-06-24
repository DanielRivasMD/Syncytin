#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# declarations
# inFile="Vulpes_vulpes.json"
inDir="${assemblyReadmeDir}"
outDir="${statsDir}"
outFile="assembly.csv"

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

  # log
  echo "${spp}"

  # collect data
  bender assembly description \
    --species "${spp}" \
    --inDir "${inDir}" \
    --outfile "${outFile}" \
    --outDir "${outDir}"

done

################################################################################

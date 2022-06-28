#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# define assembly
species=$(sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1)
assembly=$(sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2)

####################################################################################################

# create directory to hold diamond output
if [[ ! -d "${diamondDir}/raw/${species}" ]]
then
  mkdir "${diamondDir}/raw/${species}"
fi

# iterate on scaffolds
for scaffold in $(command ls "${dataDir}/tmp/${species}")
do

  # similarity search
  bender assembly search diamond \
    --configPath "${explorationDir}/config/" \
    --configFile "diamond.toml" \
    --inDir "${dataDir}/tmp/${species}" \
    --outDir "${diamondDir}/raw/${species}" \
    --species "${species}" \
    --assembly "${assembly}" \
    --scaffold "${scaffold}"

done

# concatenate output
cat "${diamondDir}/raw/${species}"/* > "${diamondDir}/raw/${species}.tsv"

####################################################################################################

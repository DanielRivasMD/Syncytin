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

# decompress assembly & keep compressed
gzip --decompress --stdout "${assemblyDir}/${assembly}" > "${dataDir}/tmp/${assembly/.gz/}"

# create directory to hold scaffolds
if [[ ! -d "${dataDir}/tmp/${species}" ]]
then
  mkdir "${dataDir}/tmp/${species}"
fi

# segregate scaffolds
bender fasta segregate \
  --inDir "${dataDir}/tmp" \
  --outDir "${dataDir}/tmp/${species}" \
  --fasta "${assembly}"

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

# remove decompressed assembly & segregated files
rm "${dataDir}/tmp/${assembly/.gz/}"
rm "${dataDir}/tmp/${species}/"*
rmdir "${dataDir}/tmp/${species}"

####################################################################################################

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
mkdir "${dataDir}/tmp/${species}"

# segregate scaffolds
bender fasta segregate \
  --inDir "${dataDir}/tmp" \
  --outDir "${dataDir}/tmp/${species}" \
  --fasta "${assembly}"

# iterate on scaffolds
for scaffold in $(command ls "${dataDir}/tmp/${species}")
do

  # similarity search
  bender assembly search diamond \
    --configPath "${sourceFolder}/src/Exploration/config/" \
    --configFile "diamond.toml" \
    --inDir "${dataDir}/tmp/${species}" \
    --species "${species}" \
    --assembly "${assembly}" \
    --scaffold "${scaffold}"

done

# remove decompressed assembly & segregated files
rm "${dataDir}/tmp/${assembly/.gz/}"
rm "${dataDir}/tmp/${species}/"*
rmdir "${dataDir}/tmp/${species}"

####################################################################################################

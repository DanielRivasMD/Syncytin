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
mkdir "${dataDir}/tmp/${assembly/.fasta.gz/}"

# segregate scaffolds
bender fasta segregate \
  --inDir "${dataDir}/tmp" \
  --outDir "${dataDir}/tmp/${assembly/.fasta.gz/}" \
  --fasta "${assembly/.gz/}"

# iterate on scaffolds
for scaffold in $(command ls "${dataDir}/tmp/${assembly/.fasta.gz/}")
do

  # similarity search
  bender assembly search diamond \
    --configPath "${sourceFolder}/src/Exploration/config/" \
    --configFile "diamond.toml" \
    --inDir "${dataDir}/tmp/${assembly/.fasta.gz/}" \
    --species "${species}" \
    --assembly "${scaffold}"

done

# remove decompressed assembly & segregated files
rm "${dataDir}/tmp/${assembly/.gz/}"
rm "${dataDir}/tmp/${assembly/.fasta.gz/}/"*
rmdir "${dataDir}/tmp/${assembly/.fasta.gz/}"

####################################################################################################

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

# similarity search
bender assembly search diamond \
  --configPath "${sourceFolder}/src/Exploration/config/" \
  --configFile "diamond.toml" \
  --inDir "${dataDir}/tmp" \
  --species "${species}" \
  --assembly "${assembly/.gz/}"

# remove decompressed assembly
rm "${dataDir}/tmp/${assembly/.gz/}"

####################################################################################################

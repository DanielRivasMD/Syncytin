#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# define slurm variables
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

# remove decompressed assembly
rm "${dataDir}/tmp/${assembly/.gz/}"

####################################################################################################

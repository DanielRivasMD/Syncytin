#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# define slurm variables
species=$(sed -n "$SLURM_ARRAY_TASK_ID"p "${DNAzooList}" | cut -d "," -f 1)
assembly=$(sed -n "$SLURM_ARRAY_TASK_ID"p "${DNAzooList}" | cut -d "," -f 2)

################################################################################

# write candidate loci
awk -v spp="${species}" 'BEGIN{FS = ","} {if ($14 == spp) print $1, $7, $8}' "${phylogenyDir}/lociDf.csv" > "${dataDir}/tmp/${species}"

# decompress assembly & keep compressed
gzip --decompress --stdout "${DNAzooDir}/${assembly}" > "${dataDir}/tmp/${assembly/.gz/}"

# collect sequences around candidate loci
while read scaffold start end
do

  # candidate
  bender assembly sequence \
    --inDir "${dataDir}/tmp" \
    --outDir "${candidateDir}" \
    --assembly "${assembly/.gz/}" \
    --species "${species}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 0

  # insertion
  bender assembly sequence \
    --inDir "${dataDir}/tmp" \
    --outDir "${insertionDir}" \
    --assembly "${assembly/.gz/}" \
    --species "${species}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 25000

done < "${dataDir}/tmp/${species}"

# remove decompressed assembly
rm "${dataDir}/tmp/${assembly/.gz/}"

# remove candidate loci
rm "${dataDir}/tmp/${species}"

################################################################################

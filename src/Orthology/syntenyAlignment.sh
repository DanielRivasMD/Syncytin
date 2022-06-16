#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# define annotation
species=$( sed -n "$SLURM_ARRAY_TASK_ID"p "${DNAzooList}" | cut -d "," -f 1 )
annotation=$( sed -n "$SLURM_ARRAY_TASK_ID"p "${DNAzooList}" | cut -d "," -f 3 )

####################################################################################################

# write candidate loci
awk -v spp="${species}" 'BEGIN{FS = ","} {if ($14 == spp) print $1, $7, $8}' "${phylogenyDir}/lociDf.csv" > "${dataDir}/tmp/${species}"

# decompress assembly & keep compressed
gzip --decompress --stdout "${annotationDir}/${annotation}" > "${dataDir}/tmp/${annotation/.gz/}"

# collect annotations around candidate loci
while read scaffold start end
do

  # annotation
  bender assembly synteny \
    --inDir "${dataDir}/tmp" \
    --outDir "${syntenyDir}" \
    --species "${annotation/.gz/}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 500000

done < "${dataDir}/tmp/${species}"

# remove decompressed annotation
rm "${dataDir}/tmp/${annotation/.gz/}"

# remove candidate loci
rm "${dataDir}/tmp/${species}"

####################################################################################################

# TODO: plot synteny

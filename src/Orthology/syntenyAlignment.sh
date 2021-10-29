#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# define annotation
annotation=$( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 3 )

################################################################################

# collect species name
spp=$( awk -v annotation="${annotation}" 'BEGIN{FS = ","} {if ( $3 == annotation ) print $1}' "${listDir}/assemblyList.csv" )

# write candidate loci
awk -v spp="${spp}" 'BEGIN{FS = ","} {if ($14 == spp) print $1, $2, $3}' "${phylogenyDir}/lociDf.csv" > "${phylogenyDir}/${spp}"

# decompress assembly & keep compressed
gzip --decompress --stdout "${annotationDir}/${annotation}" > "${annotationDir}/${annotation/.gz/}"

# collect annotations around candidate loci
while read scaffold start end
do

  # annotation
  bender assembly synteny \
    --inDir "${annotationDir}" \
    --outDir "${syntenyDir}" \
    --species "${annotation/.gz/}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 500000

done < "${phylogenyDir}/${spp}"

# remove decompressed annotation
rm "${annotationDir}/${annotation/.gz/}"

# remove candidate loci
rm "${phylogenyDir}/${spp}"

################################################################################

# TODO: plot synteny

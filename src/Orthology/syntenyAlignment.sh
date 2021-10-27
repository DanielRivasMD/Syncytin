#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# define annotation
align=$( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 3 )

################################################################################

# collect species name
spp=$( awk -v align="${align}" 'BEGIN{FS = ","} {if ( $3 == align ) print $1}' "${wasabi}/filter/assemblyList.csv" )

# write candidate loci
awk -v spp="${spp}" 'BEGIN{FS = ","} {if ($8 == spp) print $1, $2, $6}' "${phylogeny}/lociDf.csv" > "${phylogeny}/${spp}"

# decompress assembly & keep compressed
gzip --decompress --stdout "${annotation}/${align}" > "${annotation}/${align/.gz/}"

# collect annotations around candidate loci
while read scaffold start end
do

  # annotation
  bender assembly synteny \
    --inDir "${annotation}" \
    --outDir "${synteny}" \
    --species "${align/.gz/}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 500000

done < "${phylogeny}/${spp}"

# remove decompressed annotation
rm "${annotation}/${align/.gz/}"

# remove candidate loci
rm "${phylogeny}/${spp}"

################################################################################

# TODO: plot synteny

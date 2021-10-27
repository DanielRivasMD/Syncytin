#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# define assembly
species=$( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1 )
assembly=$( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )

################################################################################

# collect species name
spp=$( awk -v assembly="${assembly}" 'BEGIN{FS = ","} {if ( $2 == assembly ) print $1}' "${wasabi}/filter/assemblyList.csv" )

# write candidate loci
awk -v spp="${spp}" 'BEGIN{FS = ","} {if ($14 == spp) print $1, $2, $3}' "${phylogeny}/lociDf.csv" > "${phylogeny}/${spp}"

# decompress assembly & keep compressed
gzip --decompress --stdout "${DNAzoo}/${assembly}" > "${DNAzoo}/${assembly/.gz/}"

# collect sequences around candidate loci
while read scaffold start end
do

  # candidate
  bender assembly sequence \
    --inDir "${DNAzoo}" \
    --outDir "${candidate}" \
    --assembly "${assembly/.gz/}" \
    --species "${species}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 0

  # insertion
  bender assembly sequence \
    --inDir "${DNAzoo}" \
    --outDir "${insertion}" \
    --assembly "${assembly/.gz/}" \
    --species "${species}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 25000

done < "${phylogeny}/${spp}"

# remove decompressed assembly
rm "${DNAzoo}/${assembly/.gz/}"

# remove candidate loci
rm "${phylogeny}/${spp}"

################################################################################

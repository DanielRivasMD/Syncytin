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
spp=$( awk -v assembly="${assembly}" 'BEGIN{FS = ","} {if ( $2 == assembly ) print $1}' "${listDir}/assemblyList.csv" )

# write candidate loci
awk -v spp="${spp}" 'BEGIN{FS = ","} {if ($14 == spp) print $1, $2, $3}' "${phylogenyDir}/lociDf.csv" > "${phylogenyDir}/${spp}"

# decompress assembly & keep compressed
gzip --decompress --stdout "${DNAzooDir}/${assembly}" > "${DNAzooDir}/${assembly/.gz/}"

# collect sequences around candidate loci
while read scaffold start end
do

  # candidate
  bender assembly sequence \
    --inDir "${DNAzooDir}" \
    --outDir "${candidateDir}" \
    --assembly "${assembly/.gz/}" \
    --species "${species}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 0

  # insertion
  bender assembly sequence \
    --inDir "${DNAzooDir}" \
    --outDir "${insertionDir}" \
    --assembly "${assembly/.gz/}" \
    --species "${species}" \
    --scaffold "${scaffold}" \
    --start "${start}" \
    --end "${end}" \
    --hood 25000

done < "${phylogenyDir}/${spp}"

# remove decompressed assembly
rm "${DNAzooDir}/${assembly/.gz/}"

# remove candidate loci
rm "${phylogenyDir}/${spp}"

################################################################################

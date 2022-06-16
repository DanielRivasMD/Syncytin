#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# define assembly
species='Monodelphis_domestica'
assembly='MonDom5_HiC.fasta.gz'

####################################################################################################

# extract sequence
awk \
  -f "${projDir}/src/Utilities/fastaOperations.awk" \
  -v line=1 \
  "${assemblyDir}/${assembly/.gz}" >"${assemblyDir}/MonDom5_chr1.fasta"

####################################################################################################

# similarity search
bender assembly search diamond \
  --configPath "${sourceFolder}/src/Exploration/config/" \
  --configFile "diamond.toml" \
  --inDir "${dataDir}" \
  --species "${species}" \
  --assembly "MonDom5_chr1.fasta"

####################################################################################################

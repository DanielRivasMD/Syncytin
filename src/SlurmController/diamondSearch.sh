#!/bin/bash

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

################################################################################
# DNAzoo
################################################################################

# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --partition highmemq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 12:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyDir="${DNAzooDir}",assemblyList="${DNAzooList}" \
  --array 68,90,92,106,120,126,132,133,142,144,145,156 \
  --array 1-$( awk 'END{print NR}' "${DNAzooList}" ) \
  "${sourceFolder}/src/Exploration/diamondSearch.sh"
# patch. run only failed assemblies

################################################################################
# NCBI
################################################################################

# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --partition highmemq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 12:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyDir="${ncbiDir}",assemblyList="${ncbiList}" \
  --array 1-$( awk 'END{print NR}' "${ncbiList}" ) \
  "${sourceFolder}/src/Exploration/diamondSearch.sh"

################################################################################

# TODO: update to extract long sequences & decompress

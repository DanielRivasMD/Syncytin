#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################
# DNAzoo
####################################################################################################

# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --partition highmemq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 24:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyDir="${DNAzooDir}",assemblyList="${DNAzooList}" \
  --array 103 \
  "${sourceFolder}/src/Exploration/diamondSearch.sh"

  # --array 1-$( awk 'END{print NR}' "${DNAzooList}" ) \

####################################################################################################
# NCBI
####################################################################################################

# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --partition highmemq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 24:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyDir="${ncbiDir}",assemblyList="${ncbiList}" \
  --array 1 \
  "${sourceFolder}/src/Exploration/diamondSearch.sh"

  # --array 1-$( awk 'END{print NR}' "${ncbiList}" ) \

####################################################################################################

# TODO: update to extract long sequences & decompress

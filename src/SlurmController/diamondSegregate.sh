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
  --array 1-100 \
  "${sourceFolder}/src/Exploration/diamondSegregate.sh"

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
  --array 101-$(awk 'END{print NR}' "${DNAzooList}") \
  "${sourceFolder}/src/Exploration/diamondSegregate.sh"

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
  --array 1-$(awk 'END{print NR}' "${ncbiList}") \
  "${sourceFolder}/src/Exploration/diamondSegregate.sh"

####################################################################################################

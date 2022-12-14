#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################
# DNAzoo
####################################################################################################

# DECOMISSIONED
sbatch \
  --account "${projectId}" \
  --clusters DECOMISSIONED \
  --partition workq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 24:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyDir="${DNAzooDir}",assemblyList="${DNAzooList}" \
  --array 1-$(awk 'END{print NR}' "${DNAzooList}") \
  "${sourceFolder}/src/Exploration/diamondSegregate.sh"

####################################################################################################
# NCBI
####################################################################################################

# DECOMISSIONED
sbatch \
  --account "${projectId}" \
  --clusters DECOMISSIONED \
  --partition workq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 24:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyDir="${ncbiDir}",assemblyList="${ncbiList}" \
  --array 1-$(awk 'END{print NR}' "${ncbiList}") \
  "${sourceFolder}/src/Exploration/diamondSegregate.sh"

####################################################################################################

#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################

# DECOMISSIONED
sbatch \
  --account "${projectId}" \
  --clusters DECOMISSIONED \
  --partition workq \
  --job-name SyntenyAlignment \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 4:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",DNAzooList="${DNAzooList}" \
  --array 1-$(awk 'END{print NR}' "${DNAzooList}") \
  "${sourceFolder}/src/Orthology/syntenyAlignment.sh"

####################################################################################################

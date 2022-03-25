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
  --export sourceFolder="${sourceFolder}",assemblyDir="${DNAzooDir}" \
  "${sourceFolder}/src/Exploration/diamondTest.sh"

################################################################################

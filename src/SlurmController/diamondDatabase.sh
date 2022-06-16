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
  --job-name DiamondDatabase \
  --output "${reportFolder}/%x_%j.out" \
  --error "${reportFolder}/%x_%j.err" \
  --time 12:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}" \
  "${sourceFolder}/src/Exploration/diamondDatabase.sh"

################################################################################

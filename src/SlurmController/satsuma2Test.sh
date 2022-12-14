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
  --job-name Satsuma2Test \
  --output "${reportFolder}/%x_%j.out" \
  --error "${reportFolder}/%x_%j.err" \
  --time 24:0:0 \
  --nodes 1 \
  "${sourceFolder}/src/Orthology/satsuma2Test.sh"

####################################################################################################

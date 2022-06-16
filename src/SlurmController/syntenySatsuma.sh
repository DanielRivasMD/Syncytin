#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################

# magnus
sbatch \
  --account "${projectId}" \
  --clusters magnus \
  --partition workq \
  --job-name SyntenySatsuma \
  --output "${reportFolder}/%x_%j.out" \
  --error "${reportFolder}/%x_%j.err" \
  --time 24:0:0 \
  --nodes 1 \
  "${sourceFolder}/src/Orthology/syntenySatsuma.sh"

####################################################################################################

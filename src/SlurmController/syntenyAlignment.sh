#!/bin/bash

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

################################################################################

# magnus
sbatch \
  --account "${projectId}" \
  --clusters magnus \
  --partition workq \
  --job-name SyntenyAlignment \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 4:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",assemblyList="${assemblyList}" \
  --array 1-$( awk 'END{print NR}' "${assemblyList}" ) \
  "${sourceFolder}/src/Orthology/syntenyAlignment.sh"

################################################################################

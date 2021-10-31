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
  --job-name SyncytinBlast \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 24:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",DNAzooList="${DNAzooList}" \
  --array 1-$( awk 'END{print NR}' "${DNAzooList}" ) \
  --wrap \
  'bender assembly search blast \
  --configPath "${sourceFolder}/src/Exploration/blast/" \
  --configFile "genomeDiamond.toml" \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${DNAzooList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${DNAzooList}" | cut -d "," -f 2 )'

################################################################################

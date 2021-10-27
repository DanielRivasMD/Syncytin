#!/bin/bash

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

################################################################################

# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 12:0:0 \
  --nodes 1 \
  --ntasks 16 \
  --export sourceFolder="${sourceFolder}",assemblyList="${assemblyList}" \
  --array 1-$( awk 'END{print NR}' "${assemblyList}" ) \
  --wrap \
  'bender assembly search diamond \
  --configPath "${sourceFolder}/src/Exploration/diamond/" \
  --configFile "genomeDiamond.toml" \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )'

################################################################################

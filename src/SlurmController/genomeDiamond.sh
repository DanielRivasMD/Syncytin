#!/bin/bash

################################################################################

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh

################################################################################

# topaz
sbatch \
  --account ${projectId} \
  --clusters topaz \
  --partition gpuq \
  --job-name SyncytinDiamond \
  --output ${reportFolder}/%x_%j_%a.out \
  --error ${reportFolder}/%x_%j_%a.err \
  --time 4:0:0 \
  --nodes 1 \
  --ntasks 16 \
  --export sourceFolder=${sourceFolder},assemblyList=${assemblyList} \
  --array 1-$( awk 'END{print NR}' ${assemblyList} ) \
  --wrap \
  'bender Assembly Search diamond \
  --configPath ${sourceFolder}/src/Exploration/diamond/ \
  --configFile genomeDiamond.toml \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )'

################################################################################

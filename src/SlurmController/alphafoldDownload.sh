#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh

################################################################################

# magnus
sbatch \
  --account ${projectId} \
  --clusters magnus \
  --partition workq \
  --job-name alphafoldDownload \
  --output ${reportFolder}/%x_%j.out \
  --error ${reportFolder}/%x_%j.err \
  --time 24:0:0 \
  --nodes 1 \
  --ntasks 4 \
  --export sourceFolder=${sourceFolder} \
  --wrap \
  '${sourceFolder}/src/Prediction/alphafold_scripts/download_all_data.sh ${sourceFolder}/data/prediction/training'

################################################################################

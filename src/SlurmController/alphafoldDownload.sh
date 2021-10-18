#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh
jobId=alphafold_download

################################################################################

sbatch \
  --account ${projectId} \
  --partition workq \
  --job-name ${jobId} \
  --output ${reportFolder}/${jobId}.out \
  --error ${reportFolder}/${jobId}.err \
  --time 24:0:0 \
  --nodes 1 \
  --ntasks 4 \
  --export sourceFolder=${sourceFolder} \
  --wrap \
  '${sourceFolder}/src/Prediction/alphafold_scripts/download_all_data.sh ${sourceFolder}/data/prediction/training'

################################################################################

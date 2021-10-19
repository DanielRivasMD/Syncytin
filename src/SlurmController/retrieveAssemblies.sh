#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh
jobId=collector_HiC_assemblies

################################################################################

# MAGNUS
sbatch \
  --account ${projectId} \
  --partition workq \
  --job-name ${jobId} \
  --output ${reportFolder}/${jobId}.out \
  --error ${reportFolder}/${jobId}.err \
  --time 24:00:00 \
  --nodes 1 \
  --ntasks 1 \
  ${sourceFolder}/src/Exploration/retrieveAssemblies.sh

################################################################################

#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=collector_HiC_assemblies

################################################################################

slurmJobId=$( sbatch \
    --account ${projectId} \
    --partition gpuq \
    --job-name ${jobId} \
    --output ${reportFolder}/${jobId}.out \
    --error ${reportFolder}/${jobId}.err \
    --time 24:00:00 \
    --nodes 1 \
    --ntasks 1 \
  ${sourceFolder}/src/Exploration/assemblies.sh )

echo ${slurmJobId}

################################################################################

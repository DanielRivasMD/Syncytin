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
  --time 4:0:0 \
  --nodes 1 \
  --ntasks 1 \
  --export sourceFolder=${sourceFolder},assemblyList=${assemblyList} \
  --array 1-$( awk 'END{print NR}' ${assemblyList} ) \
  --wrap \
  '${sourceFolder}/src/Exploration/retrieveAssemblies.sh $( sed -n "$SLURM_ARRAY_TASK_ID"p ${assemblyList} )'

################################################################################

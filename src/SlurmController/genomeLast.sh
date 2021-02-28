#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinLast

################################################################################

slurmJobId=$( sbatch \
    --account ${projectId} \
    --job-name ${jobId} \
    --output ${reportFolder}/${jobId}.out \
    --error ${reportFolder}/${jobId}.err \
    --time 10:0:0 \
    --nodes 1 \
    --ntasks 1 \
    --array 1-$( awk 'END{print NR}' ${inputLs} ) \
    --export inputLs=${sourceFolder}/data/assembly.list \
  --wrap "bender --config ${sourceFolder}/src/last/genomeLast.toml GenomeLast --genome $(sed -n "$SLURM_ARRAY_TASK_ID"p ${inputLs})" )

echo ${slurmJobId}

################################################################################

#!/bin/bash

# NOTE: runs on Magnus for parallelization
source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinBlast

################################################################################

slurmJobId=$( sbatch \
    --account ${projectId} \
    --partition gpuq \
    --job-name ${jobId} \
    --output ${reportFolder}/${jobId}.out \
    --error ${reportFolder}/${jobId}.err \
    --time 24:0:0 \
    --nodes 1 \
    --ntasks 1 \
    --export sourceFolder=${sourceFolder} \
    --array 1-$( awk 'END{print NR}' ${sourceFolder}/data/CURATEDassembly.list ) \
    --wrap \
      "bender GenomeBlast \
        --config ${sourceFolder}/src/last/genomeBlast.toml \
        --species $( awk -v slurm_task_id=$SLURM_ARRAY_TASK_ID 'NR == slurm_task_id {print $1}' ${sourceFolder}/data/CURATEDassembly.list ) \
        --assembly $( awk -v slurm_task_id=$SLURM_ARRAY_TASK_ID 'NR == slurm_task_id {print $2}' ${sourceFolder}/data/CURATEDassembly.list )" \
  )

echo ${slurmJobId}

################################################################################

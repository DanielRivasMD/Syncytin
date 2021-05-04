#!/bin/bash

# NOTE: runs on Magnus for parallelization
source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinLast

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
  --array 1-$( awk 'END{print NR}' ${sourceFolder}/data/assembly.list ) \
  --wrap \
    'bender AssemblySearch last --config ${sourceFolder}/src/last/genomeLast.toml \
    --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f1 ) \
    --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f2 )'

echo ${slurmJobId}

################################################################################

#!/bin/bash

# NOTE: runs on Magnus for parallelization
source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinBlast

################################################################################

slurmJobId=$( sbatch \
    --account ${projectId} \
    --partition workq \
    --job-name ${jobId} \
    --output ${reportFolder}/${jobId}.out \
    --error ${reportFolder}/${jobId}.err \
    --time 10:0:0 \
    --nodes 1 \
    --ntasks 1 \
    --array 1-$( awk 'END{print NR}' ${sourceFolder}/data/assembly.list ) \
  --wrap 'bender --config ${sourceFolder}/src/last/genomeBlast.toml GenomeBlast --genome $(sed -n "$SLURM_ARRAY_TASK_ID"p /home/drivas/Factorem/Syncytin/data/assembly.list )' )

echo ${slurmJobId}

################################################################################

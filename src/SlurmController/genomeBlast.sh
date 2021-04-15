#!/bin/bash

# NOTE: runs on Magnus for parallelization
source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinBlast

################################################################################

# TODO: write a bounty collector
sbatch \
  --account ${projectId} \
  --partition gpuq \
  --job-name ${jobId} \
  --output ${reportFolder}/${jobId}.out \
  --error ${reportFolder}/${jobId}.err \
  --time 24:0:0 \
  --nodes 1 \
  --ntasks 1 \
  --export sourceFolder=${sourceFolder} \
  --array 1-$( awk 'END{print NR}' ${curatedAssembly} ) \
  --wrap \
    'bender GenomeBlast --config ${sourceFolder}/src/blast/genomeBlast.toml \
    --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f1 ) \
    --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f2 )'

################################################################################

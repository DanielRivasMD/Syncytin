#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinBlast

################################################################################

sbatch \
  --account ${projectId} \
  --partition workq \
  --job-name ${jobId} \
  --output ${reportFolder}/${jobId}.out \
  --error ${reportFolder}/${jobId}.err \
  --time 24:0:0 \
  --nodes 1 \
  --ntasks 1 \
  --export sourceFolder=${sourceFolder},curatedAssembly=${curatedAssembly} \
  --array 1-$( awk 'END{print NR}' ${curatedAssembly} ) \
  --wrap \
  'bender AssemblySearch blast \
  --configPath ${sourceFolder}/src/blast/ \
  --configFile genomeDiamond.toml \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f2 )'

################################################################################

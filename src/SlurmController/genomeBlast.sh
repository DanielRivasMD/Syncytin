#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh
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
  --export sourceFolder=${sourceFolder},assemblyList=${assemblyList} \
  --array 1-$( awk 'END{print NR}' ${assemblyList} ) \
  --wrap \
  'bender Assembly Search blast \
  --configPath ${sourceFolder}/src/blast/ \
  --configFile genomeDiamond.toml \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )'

################################################################################

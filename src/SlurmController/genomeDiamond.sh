#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh
jobId=SyncytinDiamond

################################################################################

sbatch \
  --account ${projectId} \
  --partition gpuq \
  --job-name ${jobId} \
  --output ${reportFolder}/topaz${jobId}.out \
  --error ${reportFolder}/topaz${jobId}.err \
  --time 4:0:0 \
  --nodes 1 \
  --ntasks 16 \
  --export sourceFolder=${sourceFolder},assemblyList=${assemblyList} \
  --array 1-$( awk 'END{print NR}' ${assemblyList} ) \
  --wrap \
  'bender Assembly Search diamond \
  --configPath ${sourceFolder}/src/diamond/ \
  --configFile genomeDiamond.toml \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )'

################################################################################e

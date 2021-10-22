#!/bin/bash

################################################################################

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh

################################################################################

# magnus
sbatch \
  --account ${projectId} \
  --clusters magnus \
  --partition workq \
  --job-name SequenceRetrieve \
  --output ${reportFolder}/%x_%j_%a.out \
  --error ${reportFolder}/%x_%j_%a.err \
  --time 4:0:0 \
  --nodes 1 \
  --ntasks 24 \
  --export sourceFolder=${sourceFolder},assemblyList=${assemblyList} \
  --array 1-$( awk 'END{print NR}' ${assemblyList} ) \
  ${sourceFolder}/src/Orthology/sequenceRetrieve.sh $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )

################################################################################

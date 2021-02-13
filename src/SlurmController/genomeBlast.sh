#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinBlast

################################################################################

slurmJobId=$( sbatch \
    --account ${projectId} \
    --job-name ${jobId} \
    --output ${reportFolder}/${jobId}.out \
    --error ${reportFolder}/${jobId}.err \
    --time 10:0:0 \
    --nodes 1 \
    --ntasks 1 \
    --array 1-${arNo} \
    --export inputLs=${inputLs} \
  ${sourceFolder}/src/blast/genomeBlast.sh )

echo ${slurmJobId}

################################################################################

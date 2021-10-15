#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh
jobId=WRITE_SLURM_JOBID_HERE

################################################################################

    # --clusters ${computingCluster} \
slurmJobId=$( sbatch \
    --account ${projectId} \
    --job-name ${jobId} \
    --output ${reportFolder}/${jobId}.out \
    --error ${reportFolder}/${jobId}.err \
    --time WRITE_TIME_HERE \
    --nodes WRITE_NODES_HERE \
    --ntasks WRITE_TASKS_HERE \
    --array 1-${arNo} \
    --export inputLs=${inputLs} \
  ${sourceFolder}/WRITE_SCRIPT_PATH_HERE.sh )

echo ${slurmJobId}

################################################################################


#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################

# cluster
sbatch \
  --account "${projectId}" \
  --clusters "CLUSTER" \
  --partition "PARTITION" \
  --job-name "JOBNAME" \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time "TIME" \
  --nodes "NODES" \
  --ntasks "TASKS" \
  --export inputLs="${inputLs}" \
  --array 1-"NUMBER" \
  --wrap \
  'SCRIPT'

####################################################################################################

# slurm variables
# %x = job-name
# %j = jobid
# %a = arrayid

# pawsey => cluster |> partition
#   DECOMISSIONED |> workq
#   topaz |> gpuq

# script
# source script.sh
# wrap 'script'

####################################################################################################

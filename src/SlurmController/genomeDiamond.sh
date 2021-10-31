#!/bin/bash

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

################################################################################
# DNAzoo
################################################################################


# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --partition highmemq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 12:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",DNAzooDir="${DNAzooDir}",assemblyList="${assemblyList}" \
  --array 1-$( awk 'END{print NR}' "${assemblyList}" ) \
  --wrap \
  'bender assembly search diamond \
  --configPath "${sourceFolder}/src/Exploration/diamond/" \
  --configFile "genomeDiamond.toml" \
  --inDir "${DNAzooDir}" \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${assemblyList}" | cut -d "," -f 2 )'


################################################################################
# NCBI
################################################################################

# zeus
sbatch \
  --account "${projectId}" \
  --clusters zeus \
  --partition highmemq \
  --job-name SyncytinDiamond \
  --output "${reportFolder}/%x_%j_%a.out" \
  --error "${reportFolder}/%x_%j_%a.err" \
  --time 12:0:0 \
  --nodes 1 \
  --export sourceFolder="${sourceFolder}",ncbiDir="${ncbiDir}",ncbiList="${ncbiList}" \
  --array 1-$( awk 'END{print NR}' "${ncbiList}" ) \
  --wrap \
  'bender assembly search diamond \
  --configPath "${sourceFolder}/src/Exploration/diamond/" \
  --configFile "genomeDiamond.toml" \
  --inDir "${ncbiDir}" \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${ncbiList}" | cut -d "," -f 1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${ncbiList}" | cut -d "," -f 2 )'

################################################################################

# TODO: update to extract long sequences & decompress

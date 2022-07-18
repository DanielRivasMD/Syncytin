#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################

# magnus
sbatch \
  --account "${projectId}" \
  --clusters magnus \
  --partition workq \
  --job-name Satsuma2Test \
  --output "${reportFolder}/%x_%j.out" \
  --error "${reportFolder}/%x_%j.err" \
  --time 24:0:0 \
  --nodes 1 \
  --wrap \
  '/home/drivas/bin/satsuma2/KMatch \
    /home/drivas/Factorem/Syncytin/data/tmp/Ailurus_fulgens/ASM200746v1_HiC_HiC_scaffold_1.fasta \
    /home/drivas/Factorem/Syncytin/data/tmp/Acinonyx_jubatus/aciJub1_HiC_HiC_scaffold_3.fasta \
    31 \
    /home/drivas/Factorem/Syncytin/data/satsumaAlignment/raw/Ailurus_fulgens/kmatch_results.k31 \
    31 \
    30 \
    1; \
    touch /home/drivas/Factorem/Syncytin/data/satsumaAlignment/raw/Ailurus_fulgens/kmatch_results.k31.finished'

####################################################################################################

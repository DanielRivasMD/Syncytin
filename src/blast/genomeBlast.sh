#!/bin/bash

################################################################################

# bash array
bashArrIt=$(sed -n "$SLURM_ARRAY_TASK_ID"p ${inputLs})

################################################################################

cd ${HOME}/Factorem/Syncytin
bender GenomeBlast \
  --genome ${bashArrIt} \
  --library protein/syncytinLibrary.fasta

################################################################################

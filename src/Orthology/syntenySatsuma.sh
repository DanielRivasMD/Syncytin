#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# # concatenate sequences
# cat "${insertionDir}/"* > "${syntenyDir}/insertionSequences.fasta"

################################################################################

# # clean satsuma directory
# rm "${satsumaDir}/"*

################################################################################

# run Satsuma
/scratch/pawsey0263/drivas/software/satsuma-code/Satsuma \
  -q "${insertionDir}/aciJub1_HiC_scaffold_3_21358328_21359746.fasta" \
  -t "${insertionDir}/UrsMar_1.0_HiC_scaffold_9_20558170_20559585.fasta" \
  -o "${satsumaDir}/"

  # -q "${syntenyDir}/insertionSequences.fasta" \
  # -t "${syntenyDir}/insertionSequences.fasta" \
  # -o "${satsumaDir}/" \
  # -self 1

################################################################################

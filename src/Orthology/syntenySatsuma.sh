#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# concatenate sequences
cat "${insertionDir}/"* > "${syntenyDir}/insertionSequences.fasta"

################################################################################

# # clean satsuma directory
# rm "${satsumaDir}/"*

################################################################################

# run Satsuma
/scratch/pawsey0263/drivas/software/satsuma-code/Satsuma \
  -q "${syntenyDir}/insertionSequences.fasta" \
  -t "${syntenyDir}/insertionSequences.fasta" \
  -o "${satsumaDir}/" \
  -self 1

################################################################################

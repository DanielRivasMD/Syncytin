#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# concatenate sequences
cat "${insertionDir}/"* > "${syntenyDir}/insertionSequences.fasta"

################################################################################

# run Satsuma
Satsuma \
-q "${syntenyDir}/insertionSequences.fasta" \
-t "${syntenyDir}/insertionSequences.fasta" \
-o "${syntenyDir}/" \
-self 1

################################################################################

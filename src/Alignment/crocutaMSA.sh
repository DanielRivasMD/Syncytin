#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

cat "${candidateDir}/Crocuta_crocuta"* > "${alignmentDir}/Crocuta_crocuta.fasta"

################################################################################

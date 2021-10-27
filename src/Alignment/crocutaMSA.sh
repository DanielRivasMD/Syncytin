#!/bin/bash
set -euo pipefail

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

cat ${candidate}/Crocuta_crocuta* > ${alignment}/Crocuta_crocuta.fasta

################################################################################

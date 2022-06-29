#!/bin/bash
# set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# define slurm variables
species="Ailurus_fulgens"

####################################################################################################

# log binary
which SatsumaSynteny2

####################################################################################################

# create directory to hold satsuma output
if [[ ! -d "${satsumaDir}/raw/${species}" ]]
then
  mkdir "${satsumaDir}/raw/${species}"
fi

# TODO: clean up the directory

####################################################################################################

# expoert satsuma
export SATSUMA2_PATH="/home/drivas/bin/satsuma2"

####################################################################################################

# run Satsuma
/home/drivas/bin/satsuma2/SatsumaSynteny2 \
  -q "${dataDir}/tmp/${species}/ASM200746v1_HiC_HiC_scaffold_1.fasta" \
  -t "${dataDir}/tmp/aciJub1_HiC.fasta" \
  -o "${satsumaDir}/raw/${species}"

####################################################################################################

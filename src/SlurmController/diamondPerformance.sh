#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################
# DNAzoo
####################################################################################################

# zeus
for bk in {0.5,1.0,1.5,2.0,2.5,3.0}
do
  for ix in {1..8}
  do

    sbatch \
      --account "${projectId}" \
      --clusters zeus \
      --partition highmemq \
      --job-name Performance \
      --output "${reportFolder}/%x_${bk}_${ix}_%j_%a.out" \
      --error "${reportFolder}/%x_${bk}_${ix}_%j_%a.err" \
      --time 24:0:0 \
      --nodes 1 \
      --export sourceFolder="${sourceFolder}",assemblyDir="${DNAzooDir}",assemblyList="${DNAzooList}",bk="${bk}",ix="${ix}" \
      --array 103 \
      "${sourceFolder}/src/Exploration/diamondPerformance.sh"

  done
done

####################################################################################################
# NCBI
####################################################################################################

# zeus
for bk in {0.5,1.0,1.5,2.0,2.5,3.0}
do
  for ix in {1..8}
  do

    sbatch \
      --account "${projectId}" \
      --clusters zeus \
      --partition highmemq \
      --job-name Performance \
      --output "${reportFolder}/%x_${bk}_${ix}_%j_%a.out" \
      --error "${reportFolder}/%x_${bk}_${ix}_%j_%a.err" \
      --time 24:0:0 \
      --nodes 1 \
      --export sourceFolder="${sourceFolder}",assemblyDir="${ncbiDir}",assemblyList="${ncbiList}",bk="${bk}",ix="${ix}" \
      --array 1 \
      "${sourceFolder}/src/Exploration/diamondPerformance.sh"

  done
done

####################################################################################################

# TODO: update to extract long sequences & decompress

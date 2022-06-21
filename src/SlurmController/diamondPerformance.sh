#!/bin/bash

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

####################################################################################################
# DNAzoo
####################################################################################################

# parameters to test
# blockSize=( 0.2 0.3 0.4 0.5 1.0 1.5 2.0 )
blockSize=( 0.4 )
indexChunksMin=100
indexChunksMax=1000
indexChunksStep=100

# zeus
for bk in "${blockSize[@]}"
do
  for ix in {${indexChunksMin}..${indexChunksMax}..${indexChunksStep}}
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

# # zeus
# for bk in "${blockSize[@]}"
# do
#   for ix in {${indexChunksMin}..${indexChunksMax}..${indexChunksStep}}
#   do

#     sbatch \
#       --account "${projectId}" \
#       --clusters zeus \
#       --partition highmemq \
#       --job-name Performance \
#       --output "${reportFolder}/%x_${bk}_${ix}_%j_%a.out" \
#       --error "${reportFolder}/%x_${bk}_${ix}_%j_%a.err" \
#       --time 24:0:0 \
#       --nodes 1 \
#       --export sourceFolder="${sourceFolder}",assemblyDir="${ncbiDir}",assemblyList="${ncbiList}",bk="${bk}",ix="${ix}" \
#       --array 1 \
#       "${sourceFolder}/src/Exploration/diamondPerformance.sh"

#   done
# done

####################################################################################################

# TODO: update to extract long sequences & decompress

#!/bin/bash

################################################################################

projId=pawsey0263
projDir=${HOME}/Factorem/Syncytin
inputLs=${projDir}/data/assembly.list
arNo=$( awk 'END{print NR}' ${inputLs} )

################################################################################

gbId=$( sbatch \
    --account $projId \
    --job-name SyncytinBlast \
    --output ${HOME}/report/SyncytinBlast.output \
    --error ${HOME}/report/SyncytinBlast.err \
    --time 10:0:0 \
    --nodes 1 \
    --ntasks 1 \
    --array 1-$arNo \
    --export inputLs=$inputLs \
  ${projDir}/src/blast/genomeBlast.sh )

echo ${gbId}

################################################################################

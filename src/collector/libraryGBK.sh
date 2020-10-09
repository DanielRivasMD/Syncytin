#!/bin/bash

################################################################################

syncProj=$HOME/Factorem/Syncytin
syncDB=${syncProj}/data/syncytinDB
accNDir=${syncDB}/accessionN

################################################################################

cd ${syncDB}/genBank

ncbi-acc-download \
  --verbose \
  --format genbank \
  $(cat ${accNDir}/*)

cd - > /dev/null

################################################################################

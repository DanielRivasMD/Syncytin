#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

cd ${diamond}

################################################################################

# create stats file
echo "Alignment,Count" > ${stats}/diamond.csv

################################################################################

# total
total=$( $(which fd) --type=directory --max-depth=1 | wc | awk '{print $1 - 1}' )

# filtered
filtered=$( $(which fd) filtered | wc | awk '{print $1}' )

# no hits
noHits=$( $(which fd) --size=0B tsv | wc | awk '{print $1}' )

# print
echo $filtered | awk '{print "Filtered," $0}' >> ${stats}/diamond.csv
echo $(( $total - ($filtered + $noHits) )) | awk '{print "NoFiltered," $0}' >> ${stats}/diamond.csv
echo $noHits | awk '{print "NoHits," $0}' >> ${stats}/diamond.csv

################################################################################

# return directory
cd - > /dev/null

################################################################################

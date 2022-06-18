#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# create stats file
echo 'Alignment,Count' > "${statsDir}/diamond.csv"

####################################################################################################

# total
cd "${diamondDir}/raw"
total=$(command find -type f | command wc | awk '{print $1}')
cd - > /dev/null

# filtered
cd "${diamondDir}/filter"
filtered=$(command find -type f | command wc | awk '{print $1}')
cd - > /dev/null

# no hits
noHits=$(command find . -type f -empty -name '*tsv' | command wc | awk '{print $1}')

# print
echo "${filtered}" | awk '{print "Filtered," $0}' >> "${statsDir}/diamond.csv"
echo $((${total} - (${filtered} + ${noHits}))) | awk '{print "NoFiltered," $0}' >> "${statsDir}/diamond.csv"
echo "${noHits}" | awk '{print "NoHits," $0}' >> "${statsDir}/diamond.csv"

####################################################################################################

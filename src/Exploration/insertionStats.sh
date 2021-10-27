#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# create stats file
echo 'Alignment,Count' > "${stats}/diamond.csv"

################################################################################

# total
cd "${diamond}/raw"
total=$( $(which fd) --type=file | wc | awk '{print $1}' )
cd - > /dev/null

# filtered
cd "${diamond}/filter"
filtered=$( $(which fd) --type=file | wc | awk '{print $1}' )
cd - > /dev/null

# no hits
noHits=$( $(which fd) --size=0B tsv | wc | awk '{print $1}' )

# print
echo "${filtered}" | awk '{print "Filtered," $0}' >> "${stats}/diamond.csv"
echo $(( ${total} - (${filtered} + ${noHits}) )) | awk '{print "NoFiltered," $0}' >> "${stats}/diamond.csv"
echo "${noHits}" | awk '{print "NoHits," $0}' >> "${stats}/diamond.csv"

################################################################################

#!/bin/bash
set -euo pipefail

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# filter alingment results
echo "Filtering alignment results..."

# iterate on diamond output items
for align in $( $(which exa) ${diamond}/raw );
do
  bender Assembly Positions -I ${diamond}/raw/${align} -O ${diamond}/filter/ -s ${align}.tsv
done

################################################################################

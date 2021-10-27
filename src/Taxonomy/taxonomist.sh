#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# taxonomy
taxGroups=(kingdom phylum class superorder order suborder family genus species subspecies)

while IFS=, read -r assemblySpp assemblyID annotationID readmeLink assemblyLink annotationLink
do

  # collect taxonomy
  echo ${assemblySpp}
  ncbi-taxonomist collect --names "${assemblySpp//_/ }" --xml > "${taxonomist}/${assemblySpp}.xml"

  # decompose taxonomy
  for tx in "${taxGroups[@]}"
  do
    grep -w -m 1 "${tx}" "${taxonomist}/${assemblySpp}.xml" > "${taxonomist}/${assemblySpp}_${tx}.xml"
  done

done < "${assemblyList}"

################################################################################

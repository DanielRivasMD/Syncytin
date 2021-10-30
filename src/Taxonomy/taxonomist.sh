#!/bin/bash
# set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# taxonomy
taxGroups=(kingdom phylum class superorder order suborder family genus species subspecies)

while IFS=, read -r assemblySpp assemblyID annotationID readmeLink assemblyLink annotationLink
do
  echo ${assemblySpp}
  # collect taxonomy
  ncbi-taxonomist collect --names "${assemblySpp//_/ }" --xml > "${taxonomistDir}/${assemblySpp}.xml"

  # decompose taxonomy
  for tx in "${taxGroups[@]}"
  do
    grep -w -m 1 "${tx}" "${taxonomistDir}/${assemblySpp}.xml" > "${taxonomistDir}/${assemblySpp}_${tx}.xml"
  done

done < "${assemblyList}"

################################################################################
# patch binominal nomenclature
################################################################################

# chinchilla hybrid, donkey, wild dog, golden hamster, rock hyrax
patchAr=("Chinchilla_lanigera" "Equus_asinus" "Lycaon_pictus" "Mesocricetus_auratus" "Procavia_capensis")

for assemblySpp in "${patchAr[@]}"
do
  echo ${assemblySpp}
  # collect taxonomy
  ncbi-taxonomist collect --names "${assemblySpp//_/ }" --xml > "${taxonomistDir}/${assemblySpp}.xml"

  # decompose taxonomy
  for tx in "${taxGroups[@]}"
  do
    grep -w -m 1 "${tx}" "${taxonomistDir}/${assemblySpp}.xml" > "${taxonomistDir}/${assemblySpp}_${tx}.xml"
  done
done

################################################################################

#!/bin/bash
# set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# ignore assemblies on taxonomy
ignoreAssembly=("Canis_lupus_dingo_alpine_ecotype" "Canis_lupus_dingo_desert_ecotype" "Canis_lupus_familiaris_Basenji" "Canis_lupus_familiaris_German_Shepherd" "Equus_asinus__ASM303372v1" "Lycaon_pictus__sis2-181106" "Mesocricetus_auratus__MesAur1.0" "Nanger_dama_ruficolis" "Procavia_capensis__Pcap_2.0")

# donkey, wild dog, golden hamster, dama gazelle, rock hyrax
patchAr=("Equus_asinus" "Lycaon_pictus" "Mesocricetus_auratus" "Nanger_dama" "Procavia_capensis")

# taxonomy
taxGroups=(class clade superorder order suborder infraorder family genus species subspecies)

####################################################################################################

function taxonomist() {

  if [[ ! "${ignoreAssembly[*]}" =~ "${assemblySpp}" ]]
  then

    # collect taxonomy
    ncbi-taxonomist collect --names "${assemblySpp//_/ }" --xml > "${taxonomistDir}/${assemblySpp}.xml"

    # decompose taxonomy
    for tx in "${taxGroups[@]}"
    do
      if [[ "${tx}" == "clade" ]]
      then
        # TODO: include monothremes
        grep -w 'Eutheria\|Metatheria' "${taxonomistDir}/${assemblySpp}.xml" >> "${taxonomistDir}/${assemblySpp}_infraclass.xml"
      else
        grep -w "${tx}" "${taxonomistDir}/${assemblySpp}.xml" >> "${taxonomistDir}/${assemblySpp}_${tx}.xml"
      fi
    done

  fi

}

####################################################################################################

while IFS=, read -r assemblySpp assemblyID annotationID readmeLink assemblyLink annotationLink
do
  echo "${assemblySpp}"
  taxonomist
done < "${DNAzooList}"

####################################################################################################
# patch binominal nomenclature
####################################################################################################

for assemblySpp in "${patchAr[@]}"
do
  echo "${assemblySpp}"
  taxonomist
done

####################################################################################################

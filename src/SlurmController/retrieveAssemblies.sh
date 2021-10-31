#!/bin/bash

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/SlurmController/syncytinConfigSLURM.sh"

################################################################################

# iterate over assembly file
while IFS=, read -r assemblySpp assemblyID annotationID readmeLink assemblyLink annotationLink
do
  source "${sourceFolder}/src/Exploration/retrieveAssemblies.sh" "${assemblySpp},${readmeLink},${assemblyLink},${annotationLink}"
done < "${DNAzooList}"

################################################################################

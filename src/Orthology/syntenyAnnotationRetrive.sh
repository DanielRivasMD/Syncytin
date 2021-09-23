#!/bin/bash

################################################################################

# declarations
projDir=$HOME/Factorem/Syncytin
phylogeny=${projDir}/src/phylogeny
excalibur=${projDir}/excalibur
annotation=${projDir}/data/annotation

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/syntenyAnnotationRetrive ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${phylogeny}/syntenyAnnotationRetrive.go
fi

# retrieve annotations
echo "Retrieving annotations..."

# iterate on available annotations
for align in $( $(which exa) ${annotation} );
do
  ${excalibur}/syntenyAnnotationRetrive ${annotation}/${align}
done

################################################################################

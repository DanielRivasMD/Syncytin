#!/bin/bash

################################################################################

syncProj=$HOME/Factorem/Syncytin
phylogeny=${syncProj}/src/phylogeny
excalibur=${syncProj}/src/excalibur
annotation=${syncProj}/data/annotation

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/syntenyAnnotationRetrive ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${phylogeny}/syntenyAnnotationRetrive.go
fi

# retrieve annotations
echo "Retrieving annotations..."

for align in $( $(which exa) ${annotation} );
do
  ${excalibur}/syntenyAnnotationRetrive ${annotation}/${align}
done

################################################################################


#!/bin/bash

################################################################################

# declarations
syncProj=$HOME/Factorem/Syncytin
phylogeny=${syncProj}/src/phylogeny
excalibur=${syncProj}/src/excalibur
diamond=${syncProj}/data/diamondOutput

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/genomicPositions ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${phylogeny}/genomicPositions.go
fi

# filter alingment results
echo "Filtering alignment results..."

# iterate on diamond output items
for align in $( $(which exa) ${diamond} );
do
  ${excalibur}/genomicPositions ${diamond}/${align}/${align}.tsv
done

################################################################################

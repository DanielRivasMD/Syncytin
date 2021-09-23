#!/bin/bash

################################################################################

# declarations
projDir=$HOME/Factorem/Syncytin
orthology=${projDir}/src/Orthology
excalibur=${projDir}/excalibur
diamond=${projDir}/data/diamondOutput

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/genomicPositions ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${orthology}/genomicPositions.go
fi

# filter alingment results
echo "Filtering alignment results..."

# iterate on diamond output items
for align in $( $(which exa) ${diamond} );
do
  ${excalibur}/genomicPositions ${diamond}/${align}/${align}.tsv
done

################################################################################

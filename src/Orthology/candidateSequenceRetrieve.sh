#!/bin/bash

################################################################################

# declarations
projDir=$HOME/Factorem/Syncytin
orthology=${projDir}/src/Orthology
excalibur=${projDir}/excalibur
dataDir=${projDir}/data
DNAzoo=${dataDir}/DNAzoo
phylogeny=${dataDir}/phylogeny

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/candidateSequenceRetrieve ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${orthology}/candidateSequenceRetrieve.go
fi

# retrieve sequences
echo "Retrieving sequences..."

# iterate on available sequences
for assembly in $( $(which exa) ${DNAzoo} );
do

  # collect species name
  spp=$( awk -v assembly=$assembly 'BEGIN{FS = ","} {if ($2 == assembly ".gz") print $1}' ${phylogeny}/assembly.list )

  # write candidate loci
  awk -v spp=$spp 'BEGIN{FS = ","} {if ($8 == spp) print $1, $2, $6}' ${phylogeny}/positionDf.csv > ${phylogeny}/${spp}

  # collect sequences around candidate loci
  while read scaffold start end
  do
    # candidate
    ${excalibur}/candidateSequenceRetrieve ${dataDir} ${assembly} ${scaffold} ${start} ${end} ""

    # upstream
    ${excalibur}/candidateSequenceRetrieve ${dataDir} ${assembly} ${scaffold} ${start} ${end} "_upstream"

    # downstream
    ${excalibur}/candidateSequenceRetrieve ${dataDir} ${assembly} ${scaffold} ${start} ${end} "_downstream"

  done < ${phylogeny}/${spp}

  # remove candidate loci
  rm ${phylogeny}/${spp}
done

################################################################################

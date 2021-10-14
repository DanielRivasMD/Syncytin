#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/syntenyAnnotationRetrieve ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${orthology}/syntenyAnnotationRetrieve.go
fi

# retrieve annotations
echo "Retrieving annotations..."

# iterate on available annotations
for align in $( $(which exa) ${annotation} );
do

  # collect species name
  spp=$( awk -v align=$align 'BEGIN{FS = ","} {if ($3 == align ".gz") print $1}' ${phylogeny}/assembly.list )

  # write candidate loci
  awk -v spp=$spp 'BEGIN{FS = ","} {if ($8 == spp) print $1, $2, $6}' ${phylogeny}/positionDf.csv > ${phylogeny}/${spp}

  # collect annotations around candidate loci
  while read scaffold start end
  do
    ${excalibur}/syntenyAnnotationRetrieve ${dataDir} ${align} ${scaffold} ${start} ${end}
  done < ${phylogeny}/${spp}

  # remove candidate loci
  rm ${phylogeny}/${spp}
done

################################################################################

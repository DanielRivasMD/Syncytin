#!/bin/bash

################################################################################

# declarations
projDir=$HOME/Factorem/Syncytin
orthology=${projDir}/src/Orthology
excalibur=${projDir}/excalibur
annotation=${projDir}/data/annotation
phylogeny=${projDir}/data/phylogeny

################################################################################

# check for Go executable
if [[ ! -x ${excalibur}/syntenyAnnotationRetrive ]]
then
  echo "Building Go executable..."
  go build -o ${excalibur}/ ${orthology}/syntenyAnnotationRetrive.go
fi

# retrieve annotations
echo "Retrieving annotations..."

# iterate on available annotations
for align in $( $(which exa) ${annotation}/*gff3 );
do
  # capture file name
  align=${align/*\/}

  # collect species name
  spp=$( awk -v align=$align 'BEGIN{FS = ","} {if ($3 == align ".gz") print $1}' ${phylogeny}/assembly.list )

  # write candidate loci
  awk -v spp=$spp 'BEGIN{FS = ","} {if ($8 == spp) print $1, $2, $6}' ${phylogeny}/positionDf.csv > ${phylogeny}/${spp}

  # collect annotations around candidate loci
  while read scaffold start end
  do
    ${excalibur}/syntenyAnnotationRetrive ${annotation}/${align} ${scaffold} ${start} ${end}
  done < ${phylogeny}/${spp}

  # remove candidate loci
  rm ${phylogeny}/${spp}
done

################################################################################

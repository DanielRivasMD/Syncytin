#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# avoid appending
if [[ -f "${listDir}/DNAzooList.csv" ]]
then
  rm "${listDir}/DNAzooList.csv"
fi

# filter
for assembly in $( $(which exa) "${wasabiDir}/raw" )
do
  awk \
    -v assemblySpp="${assembly/.csv/}" \
    '
    BEGIN{
      FS = ",";
      OFS = ","
      RS = "\r\n"
    }

    {
      if ( /README/ ) {
        readmeLink = $2;
      }

      if ( /HiC.fasta.gz/ ) {
        assembly++;
        assemblyID = $1;
        assemblyLink = $2;
      }

      if ( /fasta_v2.functional.gff3.gz/ ) {
        annotation++;
        annotationID = $1;
        annotationLink = $2;
      }
    }

    END{
      if ( annotation > 0 && assembly > 0 ) {
        print assemblySpp, assemblyID, annotationID, readmeLink, assemblyLink, annotationLink;
      }
    }
  ' "${wasabiDir}/raw/${assembly}" >> "${listDir}/DNAzooList.csv"
done

################################################################################

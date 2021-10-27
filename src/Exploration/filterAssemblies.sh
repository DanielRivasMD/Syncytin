#!/bin/bash
set -euo pipefail

################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

################################################################################

# avoid appending
if [[ -f "${wasabi}/filter/assemblyList.csv" ]]
then
  rm "${wasabi}/filter/assemblyList.csv"
fi

# filter
for assembly in $( $(which exa) "${wasabi}/raw" )
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
  ' ${wasabi}/raw/${assembly} >> ${wasabi}/filter/assemblyList.csv
done

################################################################################

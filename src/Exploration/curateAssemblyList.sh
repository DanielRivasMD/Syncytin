#!/bin/bash

################################################################################

# config
source ${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh

################################################################################

# select HiC & annotated assemblies
awk '
  BEGIN{
    FS = ",";
    OFS = " "
  }

  {
    $2 ~/HiC/ && $3 !~/NA/ {
      for (ix = 1; ix <= NF; ix++) {
        printf $ix
      }
      printf "\n"
    }
  }
' ${phylogeny}/assembly.list > ${phylogeny}/CURATEDassembly.list

################################################################################

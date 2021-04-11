#!/bin/bash

awk 'BEGIN{FS = ","; OFS = " "} $2 ~/HiC/ && $3 !~/NA/ {for (ix = 1; ix <= NF; ix++) {printf $ix} printf "\n" }' $HOME/Factorem/Syncytin/data/assembly.list > $HOME/Factorem/Syncytin/data/CURATEDassembly.listt


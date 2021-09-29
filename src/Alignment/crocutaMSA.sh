#!/bin/bash

################################################################################

# declarations
projDir=$HOME/Factorem/Syncytin
dataDir=${projDir}/data
alignment=${dataDir}/alignment
candidate=${dataDir}/candidate

################################################################################

cat ${candidate}/Crocuta_crocuta* > ${alignment}/Crocuta_crocuta.fasta

################################################################################

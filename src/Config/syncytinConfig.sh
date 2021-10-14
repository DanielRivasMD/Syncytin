#!/bin/bash

################################################################################

# declarations
projDir=${HOME}/Factorem/Syncytin

# executable
excalibur=${projDir}/excalibur

# source
srcDir=${projDir}/src
orthology=${srcDir}/Orthology
collector=${srcDir}/Collection

# data
dataDir=${projDir}/data
alignment=${dataDir}/alignment
annotation=${dataDir}/annotation
candidate=${dataDir}/candidate
diamond=${dataDir}/diamondOutput
stats=${diamond}/stats

DNAzoo=${dataDir}/DNAzoo
phylogeny=${dataDir}/phylogeny

syncDB=${dataDir}/syncytinDB
accNDir=${syncDB}/accessionN
accPDir=${syncDB}/accessionP
genBank=${syncDB}/genBank

################################################################################

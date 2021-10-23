#!/bin/bash
set -euo pipefail

#################################################################################

# declarations
syncytin="${HOME}/Factorem/Syncytin"

#################################################################################

pawseyID="drivas@topaz.pawsey.org.au"
pawseyProj="/scratch/pawsey0263/drivas"
syncytinRemote="${pawseyProj}/Factorem/Syncytin"
reportRemote="${pawseyProj}/Report/Syncytin"

#################################################################################

alignment="data/alignment"
annotation="data/annotation"
assembly="data/assembly"
candidate="data/candidate"
diamondOutput="data/diamondOutput"
DNAzoo="data/DNAzoo"
insertion="data/insertion"
phylogeny="data/phylogeny"
prediction="data/prediction"
profile="data/profile"
syncytinDB="data/syncytinDB"
synteny="data/synteny"
taxonomist="data/taxonomist"
wasabi="data/wasabi"

#################################################################################

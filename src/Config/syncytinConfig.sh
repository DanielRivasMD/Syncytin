#!/bin/bash
set -euo pipefail

################################################################################

# declarations
projDir="${HOME}/Factorem/Syncytin"

# executable
excalibur="${projDir}/excalibur"

# source
srcDir="${projDir}/src"

orthology="${srcDir}/Orthology"
collector="${srcDir}/Collection"
exploration="${srcDir}/Exploration"

# data
dataDir="${projDir}/data"

alignment="${dataDir}/alignment"
annotation="${dataDir}/annotation"
assembly="${dataDir}/assembly"
candidate="${dataDir}/candidate"
diamond="${dataDir}/diamondOutput"
DNAzoo="${dataDir}/DNAzoo"
insertion="${dataDir}/insertion"
phylogeny="${dataDir}/phylogeny"
prediction="${dataDir}/prediction"
profile="${dataDir}/profile"
stats="${dataDir}/stats"
synteny="${dataDir}/synteny"
taxonomist="${dataDir}/taxonomist"
wasabi="${dataDir}/wasabi"

syncDB="${dataDir}/syncytinDB"
accNDir="${syncDB}/accessionN"
accPDir="${syncDB}/accessionP"
genBank="${syncDB}/genBank"

################################################################################

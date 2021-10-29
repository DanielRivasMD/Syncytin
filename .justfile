################################################################################

_default:
  @just --list

################################################################################

# print justfile
print:
  bat .justfile --language make

################################################################################
# cluster deployment
################################################################################

# deliver repository to remote cluster
Source:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Deploying source to Pawsey...'
  rsync -azvhP --delete "${projDir}/src" "${pawseyID}:${projRemote}/"

################################################################################

# deliver data to remote cluster
Database:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Deploying data to Pawsey...'
  # data
  rsync -azvhP --delete "${projDir}/${listDir}/assemblyList.csv" "${pawseyID}:${projRemote}/${listDir}/" # assembly list
  rsync -azvhP --delete "${projDir}/${databaseDir}" "${pawseyID}:${projRemote}/data/"                     # syncytin data base
  rsync -zavhP --delete "${projDir}/${phylogenyDir}/lociDf.csv" "${pawseyID}:${projRemote}/${phylogenyDir}/"   # candidate loci
  rsync -zavhP --delete "${projDir}/${ncbi}/" "${pawseyID}:${projRemote}/${ncbi}/"                       # candidate loci

################################################################################

# create data folders on remote cluster
Paths:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Forging data directories at Pawsey...'
  # create directories
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${listDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${listDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${alignmentDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${alignmentDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${annotationDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${annotationDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${assemblyDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${assemblyDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${candidateDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${candidateDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${diamondDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${diamondDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${diamondDir}/raw ]]; then ssh ${pawseyID} mkdir ${projRemote}/${diamondDir}/raw; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${diamondDir}/filter ]]; then ssh ${pawseyID} mkdir ${projRemote}/${diamondDir}/filter; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${DNAzooDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${DNAzooDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${insertionDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${insertionDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${ncbiAssemblyDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${ncbiAssemblyDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${phylogenyDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${phylogenyDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${predictionDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${predictionDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${predictionDir}/training ]]; then ssh ${pawseyID} mkdir ${projRemote}/${predictionDir}/training; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${profileDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${profileDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${databaseDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${databaseDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${syntenyDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${syntenyDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${taxonomistDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${taxonomistDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${wasabiDir} ]]; then ssh ${pawseyID} mkdir ${projRemote}/${wasabiDir}; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${wasabiDir}/raw ]]; then ssh ${pawseyID} mkdir ${projRemote}/${wasabiDir}/raw; fi"
  ssh ${pawseyID} "if [[ ! -d ${projRemote}/${wasabiDir}/filter ]]; then ssh ${pawseyID} mkdir ${projRemote}/${wasabiDir}/filter; fi"

################################################################################

# retrieve data from remote
Diamond:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Retriving data...'
  rsync -azvhP "${pawseyID}:${projRemote}/${diamondDir}" "${projDir}/data/"   # diamond output
  rsync -azvhP "${pawseyID}:${projRemote}/${candidateDir}" "${projDir}/data/" # syncytin hit sequence
  rsync -azvhP "${pawseyID}:${projRemote}/${insertionDir}" "${projDir}/data/" # potential insertion sequence
  rsync -azvhP "${pawseyID}:${projRemote}/${syntenyDir}" "${projDir}/data/"   # synteny anchors

################################################################################

# retrieve reports from remote
Report:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Retriving reports...'
  rsync -azvhP --delete "${pawseyID}:${reportRemote}/" "${projDir}/report/"

################################################################################
# local analysis protocols
################################################################################

################################################################################
# collection
################################################################################

# collect species descriptions
@ assemblyStats:
  source src/Collection/assemblyStats.sh

################################################################################
# exploration
################################################################################

# collect list from wasabi
@ collectList:
  source src/Exploration/collectList.sh

################################################################################

# filter assemblies
@ filterAssemblies:
  source src/Exploration/filterAssemblies.sh

################################################################################

# insertion stats
@ insertionStats:
  source src/Exploration/insertionStats.sh
  R --slave --vanilla < src/Exploration/insertionStats.R

################################################################################
# orthology
################################################################################

# extract genomic loci coordinates
@ genomicLoci:
  # filter loci on each similarity alignment result
  echo 'Filtering genomic loci...'
  source src/Orthology/genomicLoci.sh

  # collect best loci in genomic neighborhood
  echo 'Collecting genomic loci...'
  julia --project src/Orthology/genomicLoci.jl

################################################################################
# taxonomy
################################################################################

# parse binominal files for time tree
@ binominalParse:
  #
  echo 'Parsing files...'
  source src/Taxonomy/binominalParse.sh

################################################################################

# collect taxonomy data
@ taxonomist:
  # collect taxonomy
  echo 'Gathering taxonomic information...'
  -source src/Taxonomy/taxonomist.sh

  # parse files & write taxonomy data frame
  echo 'Collecting taxons...'
  julia --project src/Taxonomy/taxonomist.jl

################################################################################

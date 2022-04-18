################################################################################

_default:
  @just --list

################################################################################

# print justfile
show:
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
  rsync -azvhP --delete "${projDir}/.just.sh" "${pawseyID}:${projRemote}/"
  rsync -azvhP --delete "${projDir}/.justfile" "${pawseyID}:${projRemote}/"

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
  rsync -azvhP --delete "${listDir}/" "${pawseyID}:${listDir/${projDir}/${projRemote}}/"            # assembly list
  rsync -azvhP --delete "${databaseDir}/" "${pawseyID}:${databaseDir/${projDir}/${projRemote}}/"    # syncytin database
  rsync -zavhP --delete "${phylogenyDir}/" "${pawseyID}:${phylogenyDir/${projDir}/${projRemote}}/"  # candidate loci
  rsync -zavhP --delete "${ncbiDir}/" "${pawseyID}:${ncbiDir/${projDir}/${projRemote}}/"            # ncbi assemblies

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
  if [[ ! -d "${listDir/${projDir}/${projRemote}}" ]]; then mkdir "${listDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${alignmentDir/${projDir}/${projRemote}}" ]]; then mkdir "${alignmentDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${annotationDir/${projDir}/${projRemote}}" ]]; then mkdir "${annotationDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${assemblyReadmeDir/${projDir}/${projRemote}}" ]]; then mkdir "${assemblyReadmeDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${candidateDir/${projDir}/${projRemote}}" ]]; then mkdir "${candidateDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${diamondDir/${projDir}/${projRemote}}" ]]; then mkdir "${diamondDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${diamondDir/${projDir}/${projRemote}}/raw" ]]; then mkdir "${diamondDir/${projDir}/${projRemote}}/raw"; fi
  if [[ ! -d "${diamondDir/${projDir}/${projRemote}}/filter" ]]; then mkdir "${diamondDir/${projDir}/${projRemote}}/filter"; fi
  if [[ ! -d "${DNAzooDir/${projDir}/${projRemote}}" ]]; then mkdir "${DNAzooDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${insertionDir/${projDir}/${projRemote}}" ]]; then mkdir "${insertionDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${ncbiDir/${projDir}/${projRemote}}" ]]; then mkdir "${ncbiDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${phylogenyDir/${projDir}/${projRemote}}" ]]; then mkdir "${phylogenyDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${predictionDir/${projDir}/${projRemote}}" ]]; then mkdir "${predictionDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${predictionDir/${projDir}/${projRemote}}/training" ]]; then mkdir "${predictionDir/${projDir}/${projRemote}}/training"; fi
  if [[ ! -d "${profileDir/${projDir}/${projRemote}}" ]]; then mkdir "${profileDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${satsumaDir/${projDir}/${projRemote}}" ]]; then mkdir "${satsumaDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${databaseDir/${projDir}/${projRemote}}" ]]; then mkdir "${databaseDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${syntenyDir/${projDir}/${projRemote}}" ]]; then mkdir "${syntenyDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${taxonomistDir/${projDir}/${projRemote}}" ]]; then mkdir "${taxonomistDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${wasabiDir/${projDir}/${projRemote}}" ]]; then mkdir "${wasabiDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${wasabiDir/${projDir}/${projRemote}}/raw" ]]; then mkdir "${wasabiDir/${projDir}/${projRemote}}/raw"; fi
  if [[ ! -d "${wasabiDir/${projDir}/${projRemote}}/filter" ]]; then mkdir "${wasabiDir/${projDir}/${projRemote}}/filter"; fi

################################################################################

# retrieve data from remote
Diamond:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Retriving data...'
  rsync -azvhP "${pawseyID}:${diamondDir/${projDir}/${projRemote}}/" "${diamondDir}/"     # diamond output
  rsync -azvhP "${pawseyID}:${candidateDir/${projDir}/${projRemote}}/" "${candidateDir}/" # syncytin hit sequence
  rsync -azvhP "${pawseyID}:${insertionDir/${projDir}/${projRemote}}/" "${insertionDir}/" # potential insertion sequence
  rsync -azvhP "${pawseyID}:${syntenyDir/${projDir}/${projRemote}}/" "${syntenyDir}/"     # synteny anchors

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

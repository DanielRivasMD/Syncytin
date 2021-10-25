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
  source .just.sh

  echo "Deploying source to Pawsey..."
  rsync -azvhP --delete "${syncytin}/src" "${pawseyID}:${syncytinRemote}/"

################################################################################

# deliver data to remote cluster
Database:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source .just.sh

  echo "Deploying data to Pawsey..."
  # data
  rsync -azvhP --delete "${syncytin}/${wasabi}/filter/assemblyList.csv" "${pawseyID}:${syncytinRemote}/${wasabi}/filter/" # assembly list
  rsync -azvhP --delete "${syncytin}/${syncytinDB}" "${pawseyID}:${syncytinRemote}/data/"                                 # syncytin data base
  rsync -zavhP --delete "${syncytin}/${phylogeny}/lociDf.csv" "${pawseyID}:${syncytinRemote}/${phylogeny}/"               # candidate loci

################################################################################

# create data folders on remote cluster
Paths:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source .just.sh

  echo "Forging data directories at Pawsey..."
  # create directories
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${alignment} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${alignment}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${annotation} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${annotation}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${assembly} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${assembly}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${candidate} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${candidate}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${diamondOutput} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${diamondOutput}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${diamondOutput}/raw ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${diamondOutput}/raw; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${diamondOutput}/filter ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${diamondOutput}/filter; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${DNAzoo} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${DNAzoo}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${insertion} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${insertion}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${phylogeny} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${phylogeny}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${prediction} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${prediction}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${prediction}/training ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${prediction}/training; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${profile} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${profile}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${syncytinDB} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${syncytinDB}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${synteny} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${synteny}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${taxonomist} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${taxonomist}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${wasabi} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${wasabi}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${wasabi}/raw ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${wasabi}/raw; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${wasabi}/filter ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${wasabi}/filter; fi"

################################################################################

# retrieve data from remote
Diamond:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source .just.sh

  echo "Retriving data..."
  rsync -azvhP "${pawseyID}:${syncytinRemote}/${diamondOutput}" "${syncytin}/data/"

################################################################################

# retrieve reports from remote
Report:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source .just.sh

  echo "Retriving reports..."
  rsync -azvhP --delete "${pawseyID}:${reportRemote}/" "${syncytin}/report/"

################################################################################
# local analysis protocols
################################################################################

################################################################################
# collection
################################################################################

# collect taxonomy data
@ taxonomist:
  # collect taxonomy
  echo "Gathering taxonomic information..."
  -source src/Taxonomy/taxonomist.sh

  # parse files & write taxonomy data frame
  echo "Collecting taxons..."
  julia --project src/Taxonomy/taxonomist.jl

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
# orthology
################################################################################

# extract genomic loci coordinates
@ genomicLoci:
  # filter loci on each similarity alignment result
  echo "Filtering genomic loci..."
  source src/Orthology/genomicLoci.sh

  # collect best loci in genomic neighborhood
  echo "Collecting genomic loci..."
  julia --project src/Orthology/genomicLoci.jl

################################################################################

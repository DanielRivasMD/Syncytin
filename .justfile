################################################################################

_default:
  @just --list

################################################################################

# print justfile
print:
  bat justfile --language make

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
  rsync -azvhP --delete "${syncytin}/${wasabi}/filter/assemblyList.csv" "${pawseyID}:${syncytinRemote}/${wasabi}/filter/"  # assembly list
  rsync -azvhP --delete "${syncytin}/${syncytinDB}" "${pawseyID}:${syncytinRemote}/data/"                                # syncytin data base

################################################################################

# GO tools
################################################################################
# create data folders on remote cluster
Paths:
  #!/bin/bash
  set -euo pipefail

# build protein accessions
@ buildProteinAccession:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Collection/proteinAcc.go
  # declarations
  source .just.sh

# run protein accessions
@ runProteinAccession:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/proteinAcc ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/proteinAcc; fi;
  source ${HOME}/Factorem/Syncytin/src/Collection/proteinAcc.sh
  echo "Forging data directories at Pawsey..."
  # create directories
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${alignment} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${alignment}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${annotation} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${annotation}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${assembly} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${assembly}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${candidate} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${candidate}; fi"
  ssh ${pawseyID} "if [[ ! -d ${syncytinRemote}/${diamondOutput} ]]; then ssh ${pawseyID} mkdir ${syncytinRemote}/${diamondOutput}; fi"
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

# build genomic positions
@ buildGenomicPositions:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Orthology/genomicPositions.go
################################################################################

# run genomic positions
@ runGenomicPositions:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/genomicPositions ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/genomicPositions; fi;
  source ${HOME}/Factorem/Syncytin/src/Orthology/genomicPositions.sh
# retrieve data from remote
Diamond:
  #!/bin/bash
  set -euo pipefail

# build synteny annotation
@ buildSyntenyAnnotationRetrieve:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Orthology/syntenyAnnotationRetrieve.go
  # declarations
  source .just.sh

# run synteny annotation
@ runSyntenyAnnotationRetrieve:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/syntenyAnnotationRetrieve ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/syntenyAnnotationRetrieve; fi
  source ${HOME}/Factorem/Syncytin/src/Orthology/syntenyAnnotationRetrieve.sh
  echo "Retriving data..."
  rsync -azvhP "${pawseyID}:${syncytinRemote}/${diamondOutput}" "${syncytin}/data/"

# build candidate sequence
@ buildCandidateSequenceRetrieve:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Orthology/candidateSequenceRetrieve.go
################################################################################

# run candidate sequence
@ runCandidateSequenceRetrieve:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/candidateSequenceRetrieve ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/candidateSequenceRetrieve; fi
  source ${HOME}/Factorem/Syncytin/src/Orthology/candidateSequenceRetrieve.sh
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

# collect list from wasabi
@ collectList:
  source ${HOME}/Factorem/Syncytin/src/Exploration/collectList.sh

################################################################################

# filter assemblies
@ filterAssemblies:
  source ${HOME}/Factorem/Syncytin/src/Exploration/filterAssemblies.sh

################################################################################

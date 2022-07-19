####################################################################################################

_default:
  @just --list

####################################################################################################

# print justfile
@show:
  bat .justfile --language make

####################################################################################################

# edit justfile
@edit:
  micro .justfile

####################################################################################################

# aliases

####################################################################################################

# julia project
@proj:
  julia --project

####################################################################################################

# julia development
@dev:
  julia -i --project --startup no --eval 'include("/Users/drivas/.archive/cerberus/julia/development.jl")'

####################################################################################################
# cluster deployment
####################################################################################################

# deliver repository to remote cluster
D-source:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Deploying source to Pawsey...'
  rsync -azvhP --delete "${projDir}/src" "${pawseyID}:${projRemote}/"
  rsync -azvhP --delete "${projDir}/.just.sh" "${pawseyID}:${projRemote}/"
  rsync -azvhP --delete "${projDir}/.justfile" "${pawseyID}:${projRemote}/"

####################################################################################################

# deliver data to remote cluster
D-database:
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

####################################################################################################

# create data folders on remote cluster
D-paths:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Forging data directories at Pawsey...'
  # create directories
  if [[ ! -d "${listDir/${projDir}/${projRemote}}" ]]; then mkdir "${listDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${dataDir/${projDir}/${projRemote}}" ]]; then mkdir "${dataDir/${projDir}/${projRemote}}"; fi
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
  if [[ ! -d "${satsumaDir/${projDir}/${projRemote}}/raw" ]]; then mkdir "${satsumaDir/${projDir}/${projRemote}}/raw"; fi
  if [[ ! -d "${satsumaDir/${projDir}/${projRemote}}/filter" ]]; then mkdir "${satsumaDir/${projDir}/${projRemote}}/filter"; fi
  if [[ ! -d "${databaseDir/${projDir}/${projRemote}}" ]]; then mkdir "${databaseDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${syntenyDir/${projDir}/${projRemote}}" ]]; then mkdir "${syntenyDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${taxonomistDir/${projDir}/${projRemote}}" ]]; then mkdir "${taxonomistDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${wasabiDir/${projDir}/${projRemote}}" ]]; then mkdir "${wasabiDir/${projDir}/${projRemote}}"; fi
  if [[ ! -d "${wasabiDir/${projDir}/${projRemote}}/raw" ]]; then mkdir "${wasabiDir/${projDir}/${projRemote}}/raw"; fi
  if [[ ! -d "${wasabiDir/${projDir}/${projRemote}}/filter" ]]; then mkdir "${wasabiDir/${projDir}/${projRemote}}/filter"; fi

####################################################################################################

# retrieve data from remote
D-diamond:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Retriving data...'
  rsync -azvhP "${pawseyID}:${databaseDir/${projDir}/${projRemote}}/" "${databaseDir}/"             # diamond database
  rsync -azvhP "${pawseyID}:${diamondDir/${projDir}/${projRemote}}/" "${diamondDir}/"               # diamond output
  rsync -azvhP "${pawseyID}:${candidateDir/${projDir}/${projRemote}}/" "${candidateDir}/"           # syncytin hit sequence
  rsync -azvhP "${pawseyID}:${insertionDir/${projDir}/${projRemote}}/" "${insertionDir}/"           # potential insertion sequence
  rsync -azvhP "${pawseyID}:${syntenyDir/${projDir}/${projRemote}}/" "${syntenyDir}/"               # synteny anchors

####################################################################################################

# retrieve reports from remote
D-report:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Retriving reports...'
  rsync -azvhP --delete "${pawseyID}:${reportRemote}/" "${projDir}/report/"

####################################################################################################

# retrieve assembly readme from remote
D-assemblyREADME:
  #!/bin/bash
  set -euo pipefail

  # declarations
  source ".just.sh"
  source "src/Config/syncytinConfig.sh"

  echo 'Retriving reports...'
  rsync -azvhP "${pawseyID}:${assemblyReadmeDir/${projDir}/${projRemote}}/" "${assemblyReadmeDir}/"

####################################################################################################
# local analysis protocols
####################################################################################################

# Vesta is the virgin goddess of the hearth, home, and family in Roman religion.
# She was rarely depicted in human form, and was more often represented by the fire of her temple in the Forum Romanum.
# Entry to her temple was permitted only to her priestesses, the Vestal Virgins, who guarded particular sacred objects within, prepared flour and sacred salt (mola salsa) for official sacrifices, and tended Vesta's sacred fire at the temple hearth.
# Their virginity was thought essential to Rome's survival; if found guilty of inchastity, they were punished by burial alive.
# As Vesta was considered a guardian of the Roman people, her festival, the Vestalia (7–15 June), was regarded as one of the most important Roman holidays.
# During the Vestalia privileged matrons walked barefoot through the city to the temple, where they presented food-offerings.
# Such was Vesta's importance to Roman religion that following the rise of Christianity, hers was one of the last non-Christian cults still active, until it was forcibly disbanded by the Christian emperor Theodosius I in AD 391.

# The myths depicting Vesta and her priestesses were few; the most notable of them were tales of miraculous impregnation of a virgin priestess by a phallus appearing in the flames of the sacred hearth — the manifestation of the goddess combined with a male supernatural being.
# In some Roman traditions, Rome's founders Romulus and Remus and the benevolent king Servius Tullius were conceived in this way.
# Vesta was among the Dii Consentes, twelve of the most honored gods in the Roman pantheon.
# She was the daughter of Saturn and Ops, and sister of Jupiter, Neptune, Pluto, Juno, and Ceres.
# Her Greek equivalent is Hestia.

####################################################################################################

####################################################################################################
# collection
####################################################################################################

# collect species descriptions
@Vesta-assemblyStats:
  source src/Collection/assemblyStats.sh

####################################################################################################
# exploration
####################################################################################################

# collect list from wasabi
@Vesta-collectList:
  source src/Exploration/collectList.sh

####################################################################################################

# filter assemblies
@Vesta-filterAssemblies:
  source src/Exploration/filterAssemblies.sh

####################################################################################################

# insertion stats
@Vesta-insertionStats:
  source src/Exploration/insertionStats.sh
  R --slave --vanilla < src/Exploration/insertionStats.R

####################################################################################################
# orthology
####################################################################################################

# extract genomic loci coordinates
@Vesta-genomicLoci:
  # filter loci on each similarity alignment result
  echo 'Filtering genomic loci...'
  source src/Orthology/genomicLoci.sh

  # collect best loci in genomic neighborhood
  echo 'Collecting genomic loci...'
  julia --project src/Orthology/genomicLoci.jl

####################################################################################################
# taxonomy
####################################################################################################

# parse binominal files for time tree
@Vesta-binominalParse:
  #
  echo 'Parsing files...'
  source src/Taxonomy/binominalParse.sh

####################################################################################################

# collect taxonomy data
@Vesta-taxonomist:
  # collect taxonomy
  echo 'Gathering taxonomic information...'
  -source src/Taxonomy/taxonomist.sh

  # parse files & write taxonomy data frame
  echo 'Collecting taxons...'
  julia --project src/Taxonomy/taxonomist.jl

####################################################################################################

################################################################################

_default:
  @just --list

################################################################################

# print justfile
print:
  bat justfile --language make

################################################################################

# deliver repository to Pawsey
@ hermesPawsey:
  echo "Deploying to Pawsey..."
  # source
  rsync -azvhP --delete ${HOME}/Factorem/Syncytin/src drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/

  # data
  rsync -azvhP --delete ${HOME}/Factorem/Syncytin/data/phylogeny/assembly.list drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/  # assembly list
  rsync -azvhP --delete ${HOME}/Factorem/Syncytin/data/phylogeny/CURATEDassembly.list drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/  # assembly list
  rsync -azvhP --delete ${HOME}/Factorem/Syncytin/data/syncytinDB drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/     # syncytin data base
  # rsync -azvhP --delete ${HOME}/Factorem/Syncytin/data/DNAzoo drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/         # DNAzoo assemblies

################################################################################

# retrieve reports from remote
@ hermesReport:
  echo "Retriving reports..."
  rsync -azvhP --delete drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Report/Syncytin/ ${HOME}/Factorem/Syncytin/report/

################################################################################

# retrieve data from remote
@ hermesData:
  echo "Retriving data..."
  rsync -azvhP drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/diamondOutput data/

################################################################################

# GO tools
################################################################################

# build protein accessions
@ buildProteinAccession:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Collection/proteinAcc.go

# run protein accessions
@ runProteinAccession:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/proteinAcc ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/proteinAcc; fi;
  source ${HOME}/Factorem/Syncytin/src/Collection/proteinAcc.sh

# build genomic positions
@ buildGenomicPositions:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Orthology/genomicPositions.go

# run genomic positions
@ runGenomicPositions:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/genomicPositions ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/genomicPositions; fi;
  source ${HOME}/Factorem/Syncytin/src/Orthology/genomicPositions.sh

# build synteny annotation
@ buildSyntenyAnnotationRetrieve:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Orthology/syntenyAnnotationRetrieve.go

# run synteny annotation
@ runSyntenyAnnotationRetrieve:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/syntenyAnnotationRetrieve ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/syntenyAnnotationRetrieve; fi
  source ${HOME}/Factorem/Syncytin/src/Orthology/syntenyAnnotationRetrieve.sh

# build candidate sequence
@ buildCandidateSequenceRetrieve:
  go build -o ${HOME}/Factorem/Syncytin/excalibur ${HOME}/Factorem/Syncytin/src/Orthology/candidateSequenceRetrieve.go

# run candidate sequence
@ runCandidateSequenceRetrieve:
  if [[ -x ${HOME}/Factorem/Syncytin/excalibur/candidateSequenceRetrieve ]]; then rm ${HOME}/Factorem/Syncytin/excalibur/candidateSequenceRetrieve; fi
  source ${HOME}/Factorem/Syncytin/src/Orthology/candidateSequenceRetrieve.sh

################################################################################

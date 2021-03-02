
################################################################################

_default:
  @just --list

################################################################################

# deliver repository to Pawsey
@ hermesPawsey:
  echo "Deploying to Pawsey..."
  # source
  rsync -azvhP --delete ${HOME}/Factorem/Syncytin/src drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/

  # data
  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/assembly.list drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/  # assembly list
  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/syncytinDB drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/     # syncytin data base
  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/DNAzoo drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/         # DNAzoo assemblies

################################################################################

# retrieve reports from remote
@ hermesReport:
  echo "Retriving reports..."
  rsync -azvhP --delete drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Report/Syncytin/ ${HOME}/Factorem/Syncytin/report/

################################################################################

# retrieve data from remote
@ hermesData:
  echo "Retriving data..."
  echo "# TODO"

################################################################################

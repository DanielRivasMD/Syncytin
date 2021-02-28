
################################################################################

_default:
  @just --list

################################################################################

# deliver repository to Pawsey
@ hermesPawsey:
  echo "Deploying to Pawsey..."
  # source
  rsync -azvhP --delete ${HOME}/Factorem/Syncytin/src drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/src
  # rsync -azvhP --delete ${HOME}/Factorem/Syncytin/src drivas@topaz.pawsey.org.au:/home/drivas/Factorem/Syncytin/src
  # rsync -azvhP --delete $HOME/Factorem/Syncytin/bender.toml drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin
  # rsync -azvhP --delete $HOME/Factorem/Syncytin/bender.toml drivas@topaz.pawsey.org.au:/home/drivas/Factorem/Syncytin

  # TODO: think about a work around about transfering data from local to remote
  # data
  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/assembly.list drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/
  # rsync -azvhP --delete $HOME/Factorem/Syncytin/data/assembly.list drivas@topaz.pawsey.org.au:/home/drivas/Factorem/Syncytin/data/
  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/syncytinDB drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/
  # rsync -azvhP --delete $HOME/Factorem/Syncytin/data/syncytinDB drivas@topaz.pawsey.org.au:/home/drivas/Factorem/Syncytin/data/

  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/DNAzoo drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/
  rsync -azvhP --delete $HOME/Factorem/Syncytin/data/output drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Factorem/Syncytin/data/

################################################################################

# retrieve reports from remote
@ hermesReport:
  echo "Retriving reports..."
  rsync -azvhP --delete drivas@topaz.pawsey.org.au:/scratch/pawsey0263/drivas/Report/Syncytin/* ${HOME}/Factorem/Syncytin/report/
  # rsync -azvhP --delete drivas@topaz.pawsey.org.au:/home/drivas/Report/Syncytin/* ${HOME}/Factorem/Syncytin/report/

################################################################################

# retrieve data from remote
@ hermesData:
  echo "Retriving data..."
  echo "# TODO"

################################################################################

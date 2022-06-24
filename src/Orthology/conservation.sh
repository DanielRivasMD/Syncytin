#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# create aminoacid alignment
clustalo --in protein/ursidae.faa --out ursidae.aln.faa
# clustalo --in protein/carnivora.faa --out carnivora.aln.faa
# # clustalo -i cluster_1.faa -o cluster_1.aln.faa

# convert aminoacid to nucleotide alignment
pal2nal.pl ursidae.aln.faa protein/ursidae.faa -output paml -nogap > ursidae.pal2nal
# pal2nal.pl carnivora.aln.faa protein/carnivora.faa -output paml -nogap > carnivora.pal2nal
# # pal2nal.pl cluster_1.aln.faa cluster_1.fna -output paml -nogap > cluster_1.pal2nal

# run paml
codeml

####################################################################################################

# segregate scaffolds
bender fasta segregate --fasta ursidae.faa --inDir protein --outDir protein/scaffold

# declare counter
ct=0

# iterate on files
for s in $(command ls "protein/scaffold")
do

  # log
  echo "${s}"

  # ((ct=ct+1))

  # # identify first sequence
  # if [[ "${ct}" == 2 ]]
  # then
  #   cc="${s}"
  # fi

  # concatenate sequences
  cat "protein/scaffold/${s}" "protein/scaffold/${s}" > "protein/compose/${s}"

  # create aminoacid alignment
  clustalo --force --in "protein/compose/${s}" --out "protein/compose/${s/.fasta/.aln.fasta}"

  # convert aminoacid to nucleotide alignment
  pal2nal.pl "protein/compose/${s/.fasta/.aln.fasta}" "protein/compose/${s}" -output paml -nogap > "protein/compose/${s/.fasta/.pal2nal}"

done

####################################################################################################

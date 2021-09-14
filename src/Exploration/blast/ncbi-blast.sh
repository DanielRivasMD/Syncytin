#!/bin/bash

################################################################################

MAGNUS=magnus.pawsey.org.au

################################################################################

# create directory
if [[ ! -d ${HOME}/software ]]
then
  mkdir -v ${HOME}/software
fi
cd software

################################################################################

# download blast toolkit
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.10.1+-x64-linux.tar.gz

# untar
tar -zxvf ncbi-blast-2.10.1+-x64-linux.tar.gz
cd ncbi-blast-2.10.1+/bin

# transfer
scp makeblastdb ${MAGNUS}:bin/
scp tblastn ${MAGNUS}:bin/

################################################################################

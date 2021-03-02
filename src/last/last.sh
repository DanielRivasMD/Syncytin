#!/bin/bash

# TODO: finish this script
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

# download last latest release
wget https://gitlab.com/mcfrith/last/-/archive/1186/last-1186.tar.gz

# untar
tar -zxvf last-1186.tar.gz
cd last-1186

# build
make

# linking

################################################################################

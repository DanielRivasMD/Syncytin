#!/bin/bash
set -euo pipefail

####################################################################################################

# download
wget http://abacus.gene.ucl.ac.uk/software/paml4.8a.macosx.tgz

####################################################################################################

# expand tarball
tar -xvf paml4.8a.macosx.tgz

# enter directory
cd paml4.8

# compile
cd src
make -f Makefile

# relocate executables
mv baseml basemlg codeml pamp evolver yn00 chi2 infinitesites mcmctree ../bin

####################################################################################################

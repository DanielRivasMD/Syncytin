#!/bin/bash
set -euo pipefail

####################################################################################################

# go to bin
cd "${HOME}/bin"

# download
wget https://github.com/bioinfologics/satsuma2/releases/download/untagged-2c08e401140c1ed03e0f/satsuma2-linux.tar.gz

####################################################################################################

# expand tarball
tar xzf satsuma2-linux.tar.gz

# relocate executables
mv product/bin satsuma2
rmdir product

####################################################################################################

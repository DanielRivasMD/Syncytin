#!/bin/bash
set -euo pipefail

####################################################################################################

# config
source "${HOME}/Factorem/Syncytin/src/Config/syncytinConfig.sh"

####################################################################################################

# build database
bender assembly database diamond \
  --configPath "${sourceFolder}/src/Exploration/config/" \
  --configFile "diamond.toml"

####################################################################################################

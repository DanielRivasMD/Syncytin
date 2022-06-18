################################################################################

# project
projDir <- '/Users/drivas/Factorem/Syncytin'

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(ggmsa)

################################################################################

# plot
ggmsa(
  paste0(projDir, '/data/syncytinDB/msa/syncytin.fasta'),
  start = 221,
  end = 280,
  char_width = 0.5,
  seq_name = FALSE
)

################################################################################

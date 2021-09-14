################################################################################

# load packages
library(tidyverse)
library(msa)

################################################################################

# declare syncytin library
synFile <- 'data/syncytinDB/protein/CURATEDsyncytinLibrary.fasta'

################################################################################

# load syncytin library
synSeq <- readAAStringSet(synFile)

################################################################################

# calculate multiple sequence alignment
synMSA <- msa(synSeq, 'ClustalW')

################################################################################

# print multiple sequence alignment
msaPrettyPrint(synMSA, output = 'pdf', showLogo = 'none', askForOverwrite = FALSE)

################################################################################

################################################################################

# load packages
library(tidyverse)
library(msa)
library(bios2mds)

################################################################################

# declare syncytin library
synFile <- 'data/syncytinDB/protein/CURATEDsyncytinLibrary.fasta'

################################################################################

# load syncytin library
synSeq <- readAAStringSet(synFile)

################################################################################

# calculate multiple sequence alignment
syncytinMSA <- msa(synSeq, 'ClustalW')

################################################################################

# print multiple sequence alignment
msaPrettyPrint(syncytinMSA, output = 'pdf', showLogo = 'none', askForOverwrite = FALSE)

################################################################################

# convert multiple sequence alignment
synMSA_as_align <- msaConvert(syncytinMSA, 'bios2mds::align')

# write multiple sequence alignment
export.fasta(synMSA_as_align, outfile = 'data/syncytinDB/msa/syncytin.fasta')

################################################################################

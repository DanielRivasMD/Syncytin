################################################################################

# project
projDir <- '/Users/drivas/Factorem/Syncytin'

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(msa)
require(bios2mds)

################################################################################

# declare syncytin library
synFile <- paste0( projDir, '/data/syncytinDB/protein/CURATEDsyncytinLibrary.fasta' )

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
export.fasta(synMSA_as_align, outfile = paste0( projDir, '/data/syncytinDB/msa/syncytin.fasta' ) )

################################################################################

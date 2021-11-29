################################################################################

# declarations
source('/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.R')

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(Biostrings)
require(msa)
require(ggmsa)

################################################################################

# sequences
# 'AEX32761.1 envelope protein syncytin-Car1 [Canis lupus familiaris]'
# 'AEX32762.1 envelope protein syncytin-Car1 [Crocuta crocuta]'
# 'AGE09538.1 envelope protein syncytin-rum1 (endogenous virus) [Bos taurus]'
# 'AGE09543.1 envelope protein syncytin-rum1 (endogenous virus) [Ovis aries]'
# 'AIQ85116.1 envelope protein syncytin-Ten1 [Echinops telfairi]'
# 'ATY46611.1 envelope protein syncytin Mab1 (endogenous virus) [Mabuya sp. NRPS-2014]'

# load sequences
syncytinSample <- readAAStringSet( paste0( databaseDir, '/protein/syncytinSample.fasta' ) )

syncytinSample %>% msa %>% msaPrettyPrint(askForOverwrite = FALSE, showLogo = 'none', showLegend = FALSE, shadingColors = 'gray', consensusThreshold = 100, consensusColors = 'Gray')

# # plot
# φ <- ggmsa(
#   syncytinSample,
#   1,
#   60,
#   char_width = 0.5,
#   color = 'Clustal',
#   seq_name = TRUE,
#   posHighligthed = 1:10,
# )

################################################################################

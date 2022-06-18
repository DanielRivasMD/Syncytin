################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(TreeTools)

################################################################################

# load tree file
trfile <- paste0(phylogenyDir, '/taxonomyBinominal.nwk')
syncytinTree <- read.tree(trfile)

################################################################################

# patch collapsed species at phylogenetic newick
# canis
canisIx <- 192
canisTree <- bind.tree(BalancedTree(2), BalancedTree(2)) %>% bind.tree(., BalancedTree(2))
canisTree$tip.label <- c('Canis lupus dingo', 'Canis lupus dingo alpine ecotype', 'Canis lupus dingo desert ecotype', 'Canis lupus familiaris', 'Canis lupus familiaris Basenji', 'Canis lupus familiaris German Shepherd')
syncytinTree <- bind.tree(syncytinTree, canisTree, canisIx) %>% DropTip(., 'Canis_lupus')

################################################################################

# patch assembly ids
# retag without underscores
syncytinTree$tip.label %<>% str_replace('_', ' ')

# patch misslabeled species
syncytinTree$tip.label[syncytinTree$tip.label == 'Aonyx cinerea'] <- 'Amblonyx cinereus'
syncytinTree$tip.label[syncytinTree$tip.label == 'Manis tricuspis'] <- 'Phataginus tricuspis'
syncytinTree$tip.label[syncytinTree$tip.label == 'Monachus schauinslandi'] <- 'Neomonachus schauinslandi'
syncytinTree$tip.label[syncytinTree$tip.label == 'Sus scrofa'] <- 'Babyrousa celebensis'
syncytinTree$tip.label[syncytinTree$tip.label == 'Lasiurus cinereus'] <- 'Aeorestes cinereus'
syncytinTree$tip.label[syncytinTree$tip.label == 'Callithrix pygmaea'] <- 'Cebuella pygmaea'

# patch subspecies
syncytinTree$tip.label[syncytinTree$tip.label == 'Equus burchellii'] <- 'Equus burchellii quagga'
syncytinTree$tip.label[syncytinTree$tip.label == 'Mustela putorius'] <- 'Mustela putorius furo'
syncytinTree$tip.label[syncytinTree$tip.label == 'Perognathus longimembris'] <- 'Perognathus longimembris pacificus'
syncytinTree$tip.label[syncytinTree$tip.label == 'Stenella longirostris'] <- 'Stenella longirostris orientalis'
syncytinTree$tip.label[syncytinTree$tip.label == 'Tragelaphus eurycerus'] <- 'Tragelaphus eurycerus isaaci'

# TODO: repatch names to fit with newick file

################################################################################

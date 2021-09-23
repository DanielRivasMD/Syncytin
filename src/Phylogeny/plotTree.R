################################################################################

# project
projDir <- '/Users/drivas/Factorem/Syncytin'

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(ggtree)
require(ggtreeExtra)
require(ggstar)
require(treeio)
require(ggnewscale)

################################################################################

# load tree file
trfile <- paste0( projDir, '/data/phylogeny/assemblyTree.nwk' )
tree <- read.tree(trfile)

# load alignment hits
dmfile <- paste0( projDir, '/data/phylogeny/diamondHits.csv' )
diamondHits <- read_csv(dmfile)

################################################################################

# create tree plot
t0 <- ggtree(
  tree, layout = 'fan'
)

# add tip labels
t1 <- t0 +
  geom_fruit(
    data = diamondHits,
    geom_point,
    mapping = aes(
      y = Species,
      size = DiamondHits,
      color = Order,
    )
  )

################################################################################

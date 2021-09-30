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

# replace no hits
diamondHits %<>% mutate(hits = na_if(hits, 0))

################################################################################

# open io
pdf( paste0( projDir, '/arch/plots/plotTree.pdf' ) )

# create tree plot
t0 <- ggtree(
  tree, layout = 'fan'
)

# add tip labels
t1 <- t0 + geom_tiplab(
  size = 1.5,
)

# add bars
t2 <- t1 +
  geom_fruit(
    data = diamondHits,
    geom = geom_bar,
    mapping = aes(
      y = Species,
      x = hits,
      fill = Order,
    ),
    stat = 'identity',
    orientation = 'y',
    offset = 0.8,
  )

t2 %>% print

# close plotting device
dev.off()

################################################################################

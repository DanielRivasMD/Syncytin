################################################################################

# project
projDir <- '/Users/drivas/Factorem/Syncytin/'

################################################################################

# load packages
library(tidyverse)
library(magrittr)
library(ggtreeExtra)
library(ggstar)
library(ggplot2)
library(ggtree)
library(treeio)
library(ggnewscale)

################################################################################

# load tree file
trfile <- 'data/phylogeny/assemblyTree.nwk'
tree <- read.tree(trfile)

# load alignment hits
dmfile <- 'data/phylogeny/diamondHits.csv'
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

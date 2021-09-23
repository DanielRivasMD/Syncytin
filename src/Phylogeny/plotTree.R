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

################################################################################

# create tree plot
t0 <- ggtree(
  tree, layout = 'fan'
)

dat1 <- data.frame(ID = tree$tip.label, n = sample(1:10, length(tree), replace = T), p = sample(1:4, length(tree), replace = T))

# add tip labels
t1 <- t0 +
  geom_fruit(
    data = dat1,
    geom_point,
    mapping = aes(
      y = ID,
      size = n,
      color = p
    )
  )

################################################################################

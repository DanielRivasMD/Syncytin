################################################################################

# project
projDir <- '/Users/drivas/Factorem/Syncytin'

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(Biostrings)
require(ggmsa)
require(ape)
require(ggtree)

################################################################################

# hyena candidate insertions
crocuta <- readDNAStringSet('data/alignment/Crocuta_crocuta.fasta')

################################################################################

# calculate distance (Levenshtein)
croDist <- as.dist(stringDist(crocuta, method = 'levenshtein') / width(crocuta)[1])

# draw tree
tree <- bionj(croDist)

# build multiple sequence alignment
croMSA <- tidy_msa(crocuta, 100, 150)

################################################################################

# open io
pdf( paste0( projDir, '/arch/plots/crocutaMSA.pdf' ) )

# plot tree
t0 <- ggtree(
    tree) +
  geom_tiplab(
    size = 2)

# plot multiple sequence alignment
t1 <- t0 +
  geom_facet(
    geom = geom_msa,
    data = croMSA,
    panel = 'msa',
    color = "Clustal") +
  xlim_tree(1.2)

t1 %>% print

# close plotting device
dev.off()

################################################################################

# TODO: translate DNA sequences
# TODO: identify transmembrane domain
# TODO: attach hydrophobicity plots

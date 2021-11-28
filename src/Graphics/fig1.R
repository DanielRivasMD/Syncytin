################################################################################

# declarations
source('/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.R')

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(ape)
require(gggenes)
require(ggtree)
require(ggmsa)

################################################################################

# tree example
tree <- rtree(150)
tree %>% ggtree(layout = 'fan', size = 1.25)

# save tree
ggsave('arch/plots/randomTree.png', width = 16, height = 16)

################################################################################

# synteny example
get_genes <- function(data, genome) {
  filter(data, molecule == genome) %>% pull(gene)
}

g <- unique(example_genes[,1])
n <- length(g)
d <- matrix(nrow = n, ncol = n)
rownames(d) <- colnames(d) <- g
genes <- lapply(g, get_genes, data = example_genes)

for (i in 1:n) {
  for (j in 1:i) {
    jaccard_sim <- length(intersect(genes[[i]], genes[[j]])) / length(union(genes[[i]], genes[[j]]))
    d[j, i] <- d[i, j] <- 1 - jaccard_sim
  }
}

tree <- ape::bionj(d)

p <- ggtree(tree, branch.length = 'none', size = 1.25) +
  xlim_tree(5.5) +
  geom_facet(mapping = aes(xmin = start, xmax = end, fill = gene),
    data = example_genes, geom = geom_motif, panel = 'Alignment',
    forward = example_genes$orientation, arrowhead_height = grid::unit(3, 'mm'), arrowhead_width = grid::unit(1, 'mm'),
    on = 'genE', align = 'left', show.legend = FALSE) +
    scale_fill_brewer(palette = "Set3") +
    scale_x_continuous(expand = c(0,0)) +
    theme(strip.text = element_blank(),
    panel.spacing = unit(0, 'cm'))

facet_widths(p, widths = c(1,2))

# save synteny
ggsave('arch/plots/syntenyExample.png', width = 16, height = 16)

################################################################################

# alignment example
protein_sequences <- system.file("extdata", "sample.fasta", package = "ggmsa")
ggmsa(protein_sequences, 221, 280, seq_name = TRUE, char_width = 0.5) + geom_seqlogo(color = "Chemistry_AA") +
  theme(
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank(),
    axis.text.y=element_blank(),
    axis.ticks.y=element_blank()
  ) +
  geom_msaBar()

# save multiple sequence alignment
ggsave('arch/plots/alignmentExample.png', width = 20, height = 16)

################################################################################

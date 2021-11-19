################################################################################

# declarations
source('/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.R')

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(gggenes)
require(ggtree)

################################################################################

# load files
source( paste0( graphDir, '/parseTree.R' ) )

################################################################################

syntenyClade <- read_csv('data/phylogenyTimeTree/syntenyCladeDf.csv')
syntenyClade %<>% mutate(orientation = ifelse(.$orientation == '+', 1, -1))
syntenyClade$spp %<>% str_replace('_', ' ')
syntenyClade$gene %<>% str_replace('Similar to ', '') %>% str_replace(' \\(.*', '') %>% toupper

################################################################################

nodeID <- 222
zynteny <- syntenyClade %>% filter(spp %in% Subtree(syncytinTree, nodeID)$tip.label)

φ <- syncytinTree %>%
  Subtree(nodeID) %>%
  ggtree(branch.length = 'none') +
  geom_tiplab() + xlim_tree(5.5) +
  geom_facet(
    mapping = aes(
      xmin = start,
      xmax = end,
      fill = gene
    ),
    # data = syntenyClade,
    data = zynteny,
    geom = geom_motif,
    on = 'SYNCYTIN',
    panel = 'Alignment',
    forward = zynteny$orientation,
    arrowhead_height = grid::unit(3, 'mm'),
    arrowhead_width = grid::unit(1, 'mm'),
    label = 'gene',
    align = 'left'
  ) +
  # scale_fill_brewer(palette = "Set3") +
  scale_x_continuous(expand = c(0,0)) +
  theme(strip.text = element_blank(),
  panel.spacing = unit(0, 'cm'))

facet_widths(φ, widths = c(1,2))

# save plot
ggsave( paste0( projDir, '/arch/plots/plotSynteny.tiff' ) )

################################################################################

# ggplot2::ggplot(zynteny, ggplot2::aes(xmin = start, xmax = end, y = spp, fill = gene)) +
# geom_gene_arrow() +
# ggplot2::facet_wrap(~ spp, scales = "free")

################################################################################

# get_genes <- function(data, genome) {
#     filter(data, molecule == genome) %>% pull(gene)
# }

# g <- unique(example_genes[,1])
# n <- length(g)
# d <- matrix(nrow = n, ncol = n)
# rownames(d) <- colnames(d) <- g
# genes <- lapply(g, get_genes, data = example_genes)

# for (i in 1:n) {
#     for (j in 1:i) {
#         jaccard_sim <- length(intersect(genes[[i]], genes[[j]])) /
#                        length(union(genes[[i]], genes[[j]]))
#         d[j, i] <- d[i, j] <- 1 - jaccard_sim
#     }
# }

# tree <- ape::bionj(d)

# p <- ggtree(tree, branch.length='none') +
# geom_tiplab() + xlim_tree(5.5) +
# geom_facet(mapping = aes(xmin = start, xmax = end, fill = gene),
#                data = example_genes, geom = geom_motif, panel = 'Alignment',
#                forward = example_genes$orientation, arrowhead_height = grid::unit(3, 'mm'), arrowhead_width = grid::unit(1, 'mm'),
#                on = 'genE', label = 'gene', align = 'left') +
#     scale_fill_brewer(palette = "Set3") +
#     scale_x_continuous(expand=c(0,0)) +
#     theme(strip.text=element_blank(),
#         panel.spacing=unit(0, 'cm'))

# facet_widths(p, widths=c(1,2))

################################################################################

################################################################################

# declarations
source('/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.R')

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(ggtree)
require(ggtreeExtra)
require(ggstar)
require(treeio)
require(ggnewscale)
require(tidytree)

################################################################################

# load files
source( paste0( graphDir, '/parseTree.R' ) )
source( paste0( graphDir, '/parseHits.R' ) )

################################################################################

# TODO: set the annotations properly
PlacentalShape <- c('Discoidal', 'Diffuse', 'Zonary', 'Cotyledonary')
Interdigitation <- c('Folded', 'Labyrinthine', 'Trabecular', 'Villous', 'Lamellar')
PlacentalInterfase <- c('Epitheliochorial', 'Endotheliochorial', 'Hemochorial')

diamondHits$PlacentalShape <- sample(PlacentalShape, dim(diamondHits)[1], replace = TRUE)
diamondHits$Interdigitation <- sample(Interdigitation, dim(diamondHits)[1], replace = TRUE)
diamondHits$PlacentalInterfase <- sample(PlacentalInterfase, dim(diamondHits)[1], replace = TRUE)

################################################################################

# create canvas
φ <- syncytinTree %>%

  # build tree
  ggtree(
    layout = 'fan',
    alpha = 0.5,
  )

φ <- φ +

  # new color scale
  new_scale_fill() +

  # add placental shape
  geom_fruit(
    data = diamondHits,
    geom = geom_tile,
    mapping = aes(
      y = treeLink,
      x = 0,
      fill = PlacentalShape,
    ),
    offset = 0.03,
    pwidth = 0.25,
  ) +

    # taxon colors
  scale_fill_discrete(
    name = 'Placental Shape',
    guide = guide_legend(
      order = 1,
    )
  )

φ <- φ +

  # new color scale
  new_scale_fill() +

  # add placental interdigitation
  geom_fruit(
    data = diamondHits,
    geom = geom_tile,
    mapping = aes(
      y = treeLink,
      x = 0,
      fill = Interdigitation,
    ),
    offset = 0.05,
    pwidth = 0.25,
  ) +

  # taxon colors
  scale_fill_discrete(
    name = 'Materno-Fetal Interdigitation',
    guide = guide_legend(
      order = 2,
    )
  )

φ <- φ +

  # new color scale
  new_scale_fill() +

  # add placental interfase
  geom_fruit(
    data = diamondHits,
    geom = geom_tile,
    mapping = aes(
      y = treeLink,
      x = 0,
      fill = PlacentalInterfase,
    ),
    offset = 0.05,
    pwidth = 0.25,
  ) +

    # taxon colors
  scale_fill_discrete(
    name = 'Placental Interfase',
    guide = guide_legend(
      order = 3,
    )
  )

φ <- φ +

  # add tip labels
  geom_tiplab(
    mapping = aes(
      label = label,
      color = group
    ),
    align = FALSE,
    offset = 3.25,
    size = 3.5,
    show.legend = FALSE,
  ) +

  # taxon colors
  scale_color_manual(
    values = taxonColors,
  )

φ <- φ +

  # new color scale
  new_scale_fill() +

  # add bars
  geom_fruit(
    data = diamondHits,
    geom = geom_bar,
    mapping = aes(
      y = treeLink,
      x = hits,
      fill = treeGroup,
    ),
    stat = 'identity',
    orientation = 'y',
    offset = 1.5,
  ) +

  # taxon colors
  scale_fill_manual(
    name = 'Taxonomical group',
    values = taxonColors,
    guide = guide_legend(
      order = 4,
    )
  )

φ <- φ +

  # add numbers
  geom_fruit(
    data = diamondHits,
    geom = geom_text,
    mapping = aes(
      y = treeLink,
      label = hits
    ),
  )

φ <- φ %<+%

  # add images
  img +
  geom_nodelab(
    aes(
      image = file,
    ),
    size = .05,
    geom = 'image',
  )

# plot
φ %>% print

################################################################################

# save plot
ggsave( paste0( projDir, '/arch/plots/plotTreeFan.png' ), width = 50, height = 50, units = 'cm')

################################################################################

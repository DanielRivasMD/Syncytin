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

  # add placental type tips
  geom_fruit(
    data = diamondHits,
    geom = geom_star,
    mapping = aes(
      y = treeLink,
      fill = placentalType,
      # starshape = placentalType,
    ),
    size = 3,
    starshape = 25,
    starstroke = 0,
    position = 'identity',
  ) +

  scale_fill_discrete(
    name = 'Placental type',
    guide = guide_legend(
      keywidth = 0.5,
      keyheight = 1,
      order = 1,
    ),
  )

  # scale_starshape_manual(
  #   values = 5:8,
  #   guide = guide_legend(
  #     keywidth = 0.5,
  #     keyheight = 0.5,
  #     order = 2,
  #   )
  # ) +

  # guides(
  #   size = 'none',
  # ) +

φ <- φ +

  # add tip labels
  geom_tiplab(
    mapping = aes(
      label = label,
      color = group
    ),
    align = FALSE,
    offset = 1,
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
    offset = 1.0,
  ) +

  # taxon colors
  scale_fill_manual(
    name = 'Taxonomical group',
    values = taxonColors,
  )

φ <- φ +

  # add numbers
  geom_fruit(
    data = diamondHits,
    geom = geom_text,
    mapping = aes(
      y = treeLink,
      label = hits
    )
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
ggsave( paste0( projDir, '/arch/plots/plotTreeFan.tiff' ) )

################################################################################

################################################################################

# project
projDir <- '/Users/drivas/Factorem/Syncytin'

################################################################################

# load packages
require(magrittr)
require(tidyverse)

################################################################################

# load diamond stats
ctfile <- paste0( projDir, '/data/diamondOutput/stats/diamond.csv' )
counts <- read_csv(ctfile)

################################################################################

# proportion
total <- sum(counts$Count)
counts$Proportion <- paste( round((counts$Count / total) * 100), '%' )

################################################################################

# open io
pdf( paste0( projDir, '/arch/plots/count.pdf' ) )

# plot
p <- {
  ggplot(
    counts,
    aes(
      Alignment,
      Count,
      fill = Alignment,
    )
  ) +
  geom_bar(stat = 'identity') +
  geom_text(
    aes(
      label = Proportion,
    ),
      color = 'black',
      size = 5,
      nudge_y = 3,
  ) +
  theme_classic() +
  ggtitle(
    'Number of assemblies explored',
    subtitle = paste( 'Number of assemblies: ', total )
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
  )
}

p %>% print

# close plotting device
dev.off()

################################################################################

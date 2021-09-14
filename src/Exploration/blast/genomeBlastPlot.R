################################################################################

# load packages
library(ggplot2)
library(dplyr)

################################################################################

# define dataframe
assemblyHits <- data.frame(
  Species = unlist(assemblyHits[, 1]),
  hits = unlist(assemblyHits[, 2])
)

################################################################################

# pdf("/Users/drivas/Factorem/Syncytin/arch/plots/GenomeBlast.pdf", width = 6, height = 4)
jpeg("/Users/drivas/Factorem/Syncytin/arch/plots/GenomeBlast.jpg", width = 1200, height = 1000)

# plot
assemblyHits %>%
  ggplot(
    aes(
      x = desc(Species),
      y = hits,
      fill = Species
    )
  ) +
  geom_bar(
    stat = "identity",
    col = "gray",
    width = 0.5
  ) +
  coord_flip(ylim = c(0, 1)) +
  xlab("") +
  ylab("") +
  theme(
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_line(size = 2),
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", colour = "grey50")
  )

dev.off()

################################################################################

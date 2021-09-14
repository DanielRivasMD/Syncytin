################################################################################

# load packages
library(ggplot2)
library(RColorBrewer)

################################################################################

jpeg('data/diamondAlingment.jpg', width = 3000, height = 1000)

noColors <- 16
moreColors <- colorRampPalette(brewer.pal(8, "Set2"))(noColors)

# plot
ggplot(data = toPlotDf, aes(x = Species, y = DiamondHits, fill = Order)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_manual(values = moreColors) +
  theme_classic() +
  theme(axis.text.x = element_text(face = "bold", size = 14, angle = 90), legend.title = element_text(face = "bold", size = 14), legend.text = element_text(face = "bold", size = 14))

dev.off()

################################################################################

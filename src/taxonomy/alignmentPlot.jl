################################################################################

# load packages
begin

  using Pkg
  Pkg.activate("/Users/drivas/Factorem/Syncytin/")

  using StatsPlots
  using DataFrames
  using FreqTables
  using RCall
end;

################################################################################

diamondHits = freqtable(positionDf.Species)
toPlotDf = taxonomyDf[:, [:Species, :Order]]

insertcols!(toPlotDf, :DiamondHits => 0)

for ρ ∈ eachrow(toPlotDf)
  ixDc = diamondHits.dicts[1]
  if haskey(ixDc, ρ.Species)
    ρ.DiamondHits = diamondHits[ixDc[r.Species]]
  end
end

################################################################################

@rput toPlotDf

R"

jpeg('data/diamondAlingment.jpg', width = 3000, height = 1000)

library(ggplot2)
library(RColorBrewer)

noColors <- 16
moreColors <- colorRampPalette(brewer.pal(8, "Set2"))(noColors)

ggplot(data = toPlotDf, aes(x = Species, y = DiamondHits, fill = Order)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_manual(values = moreColors) +
  theme_classic() +
  theme(axis.text.x = element_text(face = "bold", size = 14, angle = 90), legend.title = element_text(face = "bold", size = 14), legend.text = element_text(face = "bold", size = 14))

dev.off()

"

################################################################################

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

R"source('src/Phylogeny/alignmentPlot.R')"

################################################################################

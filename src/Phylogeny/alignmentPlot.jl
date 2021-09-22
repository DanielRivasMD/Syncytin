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

# TODO: dependes on genomicPositions. perhaps write to csv
# TODO: dependes on taxonomist. perhaps also write to csv
diamondHits = freqtable(positionDf.Species)
toPlotDf = taxonomyDf[:, [:Species, :Order]]

insertcols!(toPlotDf, :DiamondHits => 0)

for ρ ∈ eachrow(toPlotDf)
  ixDc = diamondHits.dicts[1]
  if haskey(ixDc, ρ.Species)
    ρ.DiamondHits = diamondHits[ixDc[ρ.Species]]
  end
end

################################################################################

@rput toPlotDf

R"source('src/Phylogeny/alignmentPlot.R')"

################################################################################

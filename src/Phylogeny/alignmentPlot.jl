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

# read position
begin
  f, h = readdlm("data/phylogeny/positionDf.csv", header = true)
  positionDf = DataFrame(f, h |> vec)
end

# read taxonomy
begin
  f, h = readdlm("data/phylogeny/taxonomyDf.csv", header = true)
  taxonomyDf = DataFrame(f, h |> vec)
end

################################################################################

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

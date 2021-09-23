################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin/"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  using StatsPlots
  using DataFrames
  using FreqTables
  using RCall
end;

################################################################################

# load modules
include( string(projDir, "src/Utilities/ioDataFrame.jl") )

################################################################################

# read position
positionDf = readdf("data/phylogeny/positionDf.csv")

# read taxonomy
taxonomyDf = readdf("data/phylogeny/taxonomyDf.csv")

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

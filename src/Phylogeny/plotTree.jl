################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  import Chain: @chain
  using StatsPlots
  using DataFrames
  using FreqTables
  using RCall
end;

################################################################################

# load modules
include( string( projDir, "/src/Utilities/ioDataFrame.jl" ) );

################################################################################

# read position
positionDf = readdf( string( projDir, "/data/phylogeny/positionDf.csv" ), ',' )

# read taxonomy
taxonomyDf = readdf( string( projDir, "/data/phylogeny/taxonomyDf.csv" ), ',' )

################################################################################

alignHits = freqtable(positionDf.Species)

diamondHits = @chain begin
  taxonomyDf[:, [:Species, :Order]]
  insertcols!(:hits => 0)
end

for ρ ∈ eachrow(diamondHits)
  ixDc = alignHits.dicts[1]
  if haskey(ixDc, ρ.Species)
    ρ.hits = alignHits[ixDc[ρ.Species]]
  end
end

################################################################################

# write csv
writedf( string( projDir, "/data/phylogeny/diamondHits.csv" ), diamondHits, ',' )

# ################################################################################
#
# @rput diamondHits
#
# R"source( paste0( $projDir, '/src/Phylogeny/plotTree.R' ) )"
#
# ################################################################################

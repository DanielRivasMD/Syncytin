################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

# load project enviroment
using Pkg
if Pkg.project().path != string( projDir, "/Project.toml" )
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
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

# read coordinates
lociDf = readdf( string( projDir, "/data/phylogeny/lociDf.csv" ), ',' )

# read taxonomy
taxonomyDf = readdf( string( projDir, "/data/phylogeny/taxonomyDf.csv" ), ',' )

################################################################################

alignHits = freqtable(lociDf.Species)

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

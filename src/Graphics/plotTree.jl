################################################################################

# declarations
begin
  include( "/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl" )
end;

################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string( projDir, "/Project.toml" )
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  import Chain: @chain

  using CSV
  using DataFrames
  using FreqTables
  using RCall
  using StatsPlots
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/ioDataFrame.jl" ) )
end;

################################################################################

# load data
begin
  # load taxonomy
  taxonomyDf = @chain begin
    CSV.read( string( phylogenyDir, "/taxonomyDf.csv" ), DataFrame )
    coalesce.("")
  end

  # load coordinates
  lociDf = CSV.read( string( phylogenyDir, "/lociDf.csv" ), DataFrame )
end;

################################################################################

alignHits = freqtable(lociDf.Species)

diamondHits = @chain begin
  taxonomyDf[:, [:Species, :Suborder]]
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
writedf( string( statsDir, "/diamondHits.csv" ), diamondHits, ',' )

# ################################################################################
#
# @rput diamondHits
#
# R"source( paste0( $projDir, '/src/Phylogeny/plotTree.R' ) )"
#
# ################################################################################

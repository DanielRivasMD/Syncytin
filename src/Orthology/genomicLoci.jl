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
  using DelimitedFiles
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/arrayOperations.jl" ) )
  include( string( utilDir, "/ioDataFrame.jl" ) )
  include( string( utilDir, "/evolutionaryCalculation.jl" ) )
end;

################################################################################

# load syncytin groups
syncytinGroups = @chain begin
  CSV.read( string( databaseDir, "/protein/CURATEDsyncytinGroups.csv" ), DataFrame, header = false )
  rename!(["Id", "Description", "Group"])
end

################################################################################

# declare data frame
lociDf = DataFrame(QueryAccession = String[], TargetAccession = String[], SequenceIdentity = Float64[], Length = Int64[], Mismatches = Int64[], GapOpenings = Int64[], QueryStart = Int64[], QueryEnd = Int64[], TargetStart = Int64[], TargetEnd = Int64[], EValue = Float64[], BitScore = Float64[], Group = String[], Species = String[])

# load assembly results
dDir = string( diamondDir, "/filter" )
spp = readdir(dDir)

# iterate on diamond output items
for υ ∈ spp
  # load assembly data
  assemblyAlign = @chain begin
    readdlm( string( dDir, "/", υ ) )
    DataFrame(:auto)
    rename!(["QueryAccession", "TargetAccession", "SequenceIdentity", "Length", "Mismatches", "GapOpenings", "QueryStart", "QueryEnd", "TargetStart", "TargetEnd", "EValue", "BitScore"])
  end

  # append columns
  @chain assemblyAlign begin
    # add syncytin group label
    insertcols!(_, :Group => repeat([""], size(_, 1)))

    # add species
    insertcols!(:Species => replace(υ, ".tsv" => ""))

    # add phylogenetic group
    _.Group = map(_.TargetAccession) do μ
      findfirst(χ -> μ == χ, syncytinGroups.Id) |> π -> getindex(syncytinGroups.Group, π) |> π -> convert(String, π)
    end
  end

  bestPositions = bestPosition(assemblyAlign)
  @debug bestPositions

  for ρ ∈ eachrow(bestPositions)
    push!(lociDf, ρ)
  end
end

################################################################################

# write csv
writedf( string( phylogenyDir, "/lociDf.csv" ), lociDf, ',' )

################################################################################

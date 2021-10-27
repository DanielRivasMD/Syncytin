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
  using DelimitedFiles
  using DataFrames
end;

################################################################################

# load modules
include( string( projDir, "/src/Utilities/ioDataFrame.jl" ) );

################################################################################

"return best position (highest identity percentage) on alignment"
function bestPosition(df::DataFrame)
  #  TODO: alternatively, find minimum e-value
  #  TODO: round start & end positions
  return combine(groupby(df, [:QueryAccession, :QueryStart, :QueryEnd])) do χ
    χ[argmax(χ.SequenceIdentity), :]
  end
end

################################################################################

# load syncytin groups
synGroups = @chain begin
  readdlm( string( projDir, "/data/syncytinDB/protein/CURATEDsyncytinGroups.csv" ), ',' )
  DataFrame(:auto)
  rename!(["Id", "Description", "Group"])
end

################################################################################

# declare data frame
lociDf = DataFrame()

# load assembly results
dDir = string( projDir, "/data/diamondOutput/filter" )
spp = readdir(dDir)

# iterate on diamond output items
for (ι, υ) ∈ enumerate(spp)
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
    _.Group = map(_.TargetAccession) do χ
      findfirst(ζ -> χ == ζ, synGroups.Id) |> π -> getindex(synGroups.Group, π) |> π -> convert(String, π)
    end
  end

  bestPositions = bestPosition(assemblyAlign)
  @debug bestPositions

  if ι == 1
    global lociDf = bestPositions
  else
    lociDf = [lociDf; bestPositions]
  end
end

################################################################################

# write csv
writedf( string( projDir, "/data/phylogeny/lociDf.csv" ), lociDf, ',' )

################################################################################

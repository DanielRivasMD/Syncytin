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
  return combine(groupby(df, [:Scaffold, :start, :Group])) do χ
    χ[argmax(χ.Identity), :]
  end
end

################################################################################

# load syncytin groups
synGroups = @chain begin
  readdlm( string( projDir, "/data/syncytinDB/protein/CURATEDsyncytinGroups.csv", ',' ) )
  DataFrame(:auto)
  rename!(["Id", "Description", "Group"])
end

################################################################################

# load assembly results
dDir = string( projDir, "/data/diamondOutput" )
dirs = readdir(dDir)

# iterate on diamond output items
for ι ∈ eachindex(dirs)
  dr = dirs[ι]
  lr = readdir( string( dDir, "/", dr ) )
  xr = contains.(lr, r"filtered")
  if sum(xr) != 0
    @debug lr[xr]

    # load assembly data
    assemblyAlign = @chain begin
      readdlm( string( dDir, "/", dr, "/", lr[xr][1] ) )
      DataFrame(:auto)
      rename!(["Scaffold", "Id", "Identity", "start", "end", "evalue"])
    end

    # append columns
    @chain assemblyAlign begin
      # add species
      insertcols!(:Species => replace(dr, "filtered.tsv" => ""))

      # add syncytin group label
      insertcols!(_, :Group => repeat([""], size(_, 1)))

      # add phylogenetic group
      _.Group = map(_.Id) do χ
        findfirst(ζ -> χ == ζ, synGroups.Id) |> π -> getindex(synGroups.Group, π) |> π -> convert(String, π)
      end
    end

    bestPositions = bestPosition(assemblyAlign)
    @debug bestPositions

    if ι == 1
      global positionDf = bestPositions
    else
      positionDf = [positionDf; bestPositions]
    end
  end
end

################################################################################

# write csv
writedf( string( projDir, "/data/phylogeny/positionDf.csv" ), positionDf, ',' )

################################################################################

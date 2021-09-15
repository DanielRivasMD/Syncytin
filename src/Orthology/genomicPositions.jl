################################################################################

# load packages
begin

  using Pkg
  Pkg.activate("/Users/drivas/Factorem/Syncytin/")

  using DelimitedFiles
  using DataFrames
end;

################################################################################

"return best position (highest identity percentage) on alignment"
function bestPosition(df::DataFrame)
  #  TODO: alternatively, find minimum e-value
  return map(groupby(df, [:Scaffold, :start, :Group])) do χ
    χ[findmax(χ.Identity)[2], :]
  end |> DataFrame
end

################################################################################

# load syncytin groups
synGroups = readdlm("data/syncytinDB/protein/CURATEDsyncytinGroups.csv", ',') |> DataFrame
rename!(synGroups, ["Id", "Description", "Group"])

################################################################################

# load assembly results
dDir = "data/diamondOutput"
dirs = readdir(dDir)

# iterate on diamond output items
for ι ∈ eachindex(dirs)
  dr = dirs[ι]
  lr = readdir( string(dDir, "/", dr) )
  xr = contains.(lr, r"filtered")
  if sum(xr) != 0
    @debug lr[xr]
    # load assembly data
    assemblyAlign = readdlm( string(dDir, "/", dr, "/", lr[xr][1]) ) |> DataFrame
    rename!(assemblyAlign, ["Scaffold", "Id", "Identity", "start", "end", "evalue"])

    # add species
    insertcols!(assemblyAlign, :Species => replace(replace(dr, "filtered.tsv" => ""), "_" => " "))

    # add syncytin group label
    insertcols!(assemblyAlign, :Group => repeat([""], size(assemblyAlign, 1)))
    assemblyAlign.Group = map(assemblyAlign.Id) do y
      findfirst(x -> y == x, synGroups.Id) |> p -> getindex(synGroups.Group, p) |> p -> convert(String, p)
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
# TODO: write dataframe to csv

################################################################################

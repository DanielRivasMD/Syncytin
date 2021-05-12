################################################################################

using DelimitedFiles
using DataFrames

################################################################################

"return best position (highest identity percentage) on alignment"
function bestPosition(df::DataFrame)
  return map(groupby(df, [:Scaffold, :start])) do x
    x[findmax(x.Identity)[2], :]
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

for dr ∈ dirs
  lr = readdir( string(dDir, "/", dr) )
  xr = contains.(lr, r"filtered")
  if sum(xr) != 0
    @info lr[xr]
    assemblyAlign = readdlm( string(dDir, "/", dr, "/", lr[xr][1]) ) |> DataFrame
    rename!(assemblyAlign, ["Scaffold", "Id", "Identity", "start", "end", "evalue"])

    insertcols!(assemblyAlign, size(assemblyAlign, 2) + 1, :Group => repeat([""], size(assemblyAlign, 1)))
    assemblyAlign.Group = map(assemblyAlign.Id) do y
      findfirst(x -> y == x, synGroups.Id) |> p -> getindex(synGroups.Group, p) |> p -> convert(String, p)
    end

    bestPositions = bestPosition(assemblyAlign)
    @info bestPositions
  end
end

################################################################################

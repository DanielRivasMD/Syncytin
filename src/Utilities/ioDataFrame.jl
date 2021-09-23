################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin/"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  using DelimitedFiles
  using DataFrames
end;

################################################################################

"read dataframe"
function readdf(path)
  f, h = readdlm(path, header = true)
  DataFrame(f, h |> vec)
end

################################################################################

"write dataframe"
function writedf(path, df::DataFrame, sep = '\t')
  toWrite = [(df |> names |> permutedims); (df |> Array)]
  writedlm(path, toWrite, sep)
end

################################################################################

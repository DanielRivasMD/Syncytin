################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  using DelimitedFiles
  using RCall
end;

################################################################################

unfilt = string( projDir, "/data/out" )
filt = string( projDir, "/data/outfilt" )

unfiltlist = readdir(unfilt)
filtlist = readdir(filt)

assemblyHits = Array{Any}(undef, length(unfiltlist), 2)
assemblyHits[:, 1] = replace.(unfiltlist, ".out" => "")
assemblyHits[:, 2] .= 0
for f in filtlist
  fr = readdlm(string(filt, '/', f), '|')
  sp = f[1:findfirst('.', f) - 1]
  assemblyHits[assemblyHits[:, 1] .== sp, 2] .= sum(fr, dims = 1)[1] / sum(fr, dims = 1)[2]
end

################################################################################

@rput assemblyHits
R"source( paste0( $projDir, '/src/blast/genomeBlastPlot.R' ) )"

################################################################################

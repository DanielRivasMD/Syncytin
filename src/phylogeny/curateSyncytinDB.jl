
#  TODO: finish this script

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

# run analysis on nucleotide & protein databases
import DelimitedFiles
db = [:nucleotide, :protein]
ad = 0

for d in [:N, :P]
  global ad += 1

  # load syncytin library

  # read sequences from file
  synAr = Symbol("synAr", d)
  @eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )

  # group syncytin sequences
  syngDf = Symbol("syngDf", d)
  @eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )


end




# curated = synArP[lenArP[:, 2] .!= 15]
# open(FASTA.Writer, synFA) do w
#   for rc in curated
#     write(w, FASTA.Record(FASTX.identifier(curated[1]), FASTX.description(curated[1]), FASTX.sequence(curated[1])))
#   end
# end


using UnicodePlots
using DelimitedFiles
# using RCall

include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");
db = [:nucleotide, :protein]
ad = 0
ad = 2
d = :P
synAr = Symbol("synAr", d)
@eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )
syngDf = Symbol("syngDf", d)
@eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )

x = FASTX.description.(synArP)
# @pipe findall(x -> contains(x, "envelope") || contains(x, "syncytin"), x) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> plot
@pipe findall(x -> contains(x, "envelope") || contains(x, "syncytin"), x) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> scatterplot

# x
# @pipe synArP |> findall(x -> FASTA.seqlen(x) < 400, _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) < 400, _) |> getindex(synArP, _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) < 400, _) |> getindex(synArP, _) |> FASTX.description(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) < 400, _) |> getindex(synArP, _) .|> FASTX.description(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) < 400, _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400, _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(x -> FASTX.description(x), _), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x, "envelope"), _), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x, "envelope")), _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x, "envelope")), _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "envelope"), _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x), "envelope"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x), "Mab"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Mab"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTA.seqlen(_) |> scatterplot(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTA.seqlen(_) |> scatterplot
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> scatterplot(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) .|> FASTA.seqlen(_) |> scatterplot(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> scatterplot(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _)
# FASTX.identifier(synArP)
# FASTX.identifier.(synArP)
# unique
# FASTX.identifier.(synArP) |> unique
# FASTX.identifier.(synArP)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTX.identifier(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTX.identifier.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "Homo"), _) |> getindex(synArP, _) |> FASTX.identifier.(_) |> unique
# @pipe synArP |> FASTX.description(_)
# @pipe synArP .|> FASTX.description(_)
# @pipe synArP |> contains(FASTX.description(_), "Endogenous")
# @pipe synArP |> contains.(FASTX.description(_), "Endogenous")
# @pipe synArP |> contains(FASTX.description.(_), "Endogenous")
# @pipe synArP |> contains.(FASTX.description.(_), "Endogenous")
# @pipe synArP |> contains.(FASTX.description.(_), "Endogenous") |> scatterplot
# @pipe synArP |> contains.(FASTX.description.(_), "retro") |> scatterplot
# @pipe synArP |> contains.(FASTX.description.(_), "retro")
# @pipe synArP |> contains.(FASTX.description.(_), "retro") |> getindex(synArP, _)
# @pipe synArP |> contains.(FASTX.description.(_), "retro") |> getindex(synArP, _) |> FASTX.description
# @pipe synArP |> contains.(FASTX.description.(_), "retro") |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x, "envelope")), _)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x), "envelope"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x), "syncytin"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "syncytin"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && !contains(FASTX.description(x), "envelope"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "syncytin") && contains(FASTX.description(x), "envelope"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "envelope"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && contains(FASTX.description(x), "syncytin"), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen(_) |> scatterplot
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> scatterplot
# UnicodePlots.histogram
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> histogram
# histogram
# UnicodePlots.histogram
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> barplot

# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen.(_)
l = @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen.(_)

# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)
n = @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)

barplot
barplot(n, l)




# n
# rtagAr = tagGroup(synArP, syngDfP)
# trimIdP = trimmer!(synArP .|> description, rtagAr .!= size(syngDfP, 1) + 1)
# trimIdP
# rtagAr = trimmer!(rtagAr, rtagAr .!= size(syngDfP, 1) + 1)
# trimIdP
# n
# map(contains(rtagAr), n)
# map(contains.(rtagAr), n)
# map(x -> contains(rtagAr, x), n)
# map(x -> contains.(rtagAr, x), n)
# n
# l
# n
# rtagAr
# trimIdP
# map(x -> contains.(trimIdP, x), n)
# map(x -> contains.(trimIdP, x), n) |> heatmap
# map(x -> contains.(trimIdP, x), n)
# reshape(map(x -> contains.(trimIdP, x), n), 150, :)
# reshape(map(x -> contains.(trimIdP, x), n), 150, :) |> heatmap
# reshape(map(x -> contains.(trimIdP, x), n), 150, :) |> UnicodePlots.heatmap
# convert.(Int64, reshape(map(x -> contains.(trimIdP, x), n), 150, :)) |> UnicodePlots.heatmap
# convert.(Int64, reshape(map(x -> contains.(trimIdP, x), n), 150, :))
# trimIdP
# reshape(map(x -> contains.(trimIdP, x), n), 150, :)
# y = reshape(map(x -> contains.(trimIdP, x), n), 150, :)
# y[1, 1]
# y
# y[1]
# y[1, 1]
# y[1, 2]
# y
# y |> length
# y |> size
# y
# map(x -> contains.(trimIdP, x), n)
# reshape(map(x -> contains.(trimIdP, x), n), :, 150)
# reshape(map(x -> contains.(trimIdP, x), n), 150, 150)
# map(x -> contains.(trimIdP, x), n)
# map(x -> findall.(trimIdP, x), n)
# map(x -> findall(trimIdP, x), n)
# map(x -> findall.(trimIdP, x), n)
# map(x -> x .== trimIdP, n)
# map(x -> x .== trimIdP, n) |> heatmap
# map(x -> x .== trimIdP, n) |> UnicodePlots.heatmap
# rand(10, 10) |> heatmap
# rand(10, 10) |> UnicodePlotsheatmap
# rand(10, 10) |> UnicodePlots.heatmap
# map(x -> x .== trimIdP, n) |> UnicodePlots.heatmap
# map(x -> x .== trimIdP, n)
# map(x -> x .== trimIdP, n) .|> sum
# map(x -> x .== trimIdP, n) .|> sum |> scatterplot
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall.(x -> x == 0, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 0, _)
# map(x -> findall.(trimIdP, x), n)
# map(x -> findall(trimIdP, x), n)
# findall.(trimIdP, n)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 0, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 0, _) |> getindex(n, _)
# map(x -> x .== trimIdP, n) .|> sum |> scatterplot
# @pipe map(x -> x .== trimIdP, n) .|> sum |> scatterplot(_, n[_])
# @pipe map(x -> x .== trimIdP, n) .|> sum |> barplot(_, n[_])
# @pipe map(x -> x .== trimIdP, n) .|> sum |> barplot(n[_], _)
# @pipe map(x -> x .== trimIdP, n) .|> barplot(n[_], _)
# @pipe map(x -> x .== trimIdP, n)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 0, _) |> getindex(n, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 1, _) |> getindex(n, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 2, _) |> getindex(n, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 3, _) |> getindex(n, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 4, _) |> getindex(n, _)
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 5, _) |> getindex(n, _)
# n
# n |> unique
# @pipe map(x -> x .== trimIdP, n) .|> sum |> findall(x -> x == 0, _) |> getindex(n, _)
# n
# n .== "envelope"
# n .== "envelope" |> scatterplot
# n .== "envelope"
# convert.(Int64, n .== "envelope")
# convert.(Int64, n .== "envelope") |> scatterplot
# convert.(Int64, contains.(x -> x == "envelope", n)) |> scatterplot
# convert.(Int64, contains.(x -> x == "envelope", n))
# contains.(x -> x == "envelope", n)
# contains(x -> x == "envelope", n)
# contains(x -> x, "envelope", n)
# contains.(x -> x, "envelope", n)
# contains.(n, "envelope")
# convert.(Int64, contains.(n, "envelope")) |> scatterplot
# convert.(Int64, contains.(n, "envelope glycoprotein")) |> scatterplot
# n[contains.(n, "envelope glycoprotein")]
# exit()
# exit()
# include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");
# db = [:nucleotide, :protein]
# ad = 2
# d = :P
# synAr = Symbol("synAr", d)
# @eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )
# syngDf = Symbol("syngDf", d)
# @eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )
# n = @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)
# n
#
#
# less ~/.julia/logs/repl_history.jl
# exit()
# using UnicodePlots
# using DelimitedFiles
# using RCall
# include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");
# db = [:nucleotide, :protein]
# ad = 0
# ad = 2
# d = :P
# synAr = Symbol("synAr", d)
# @eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )
# syngDf = Symbol("syngDf", d)
# @eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )
# x = FASTX.description.(synArP)
# exit()
# using UnicodePlots
# using DelimitedFiles
# include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");
# db = [:nucleotide, :protein]
# ad = 0
# ad = 2
# d = :P
# synAr = Symbol("synAr", d)
# @eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )
# syngDf = Symbol("syngDf", d)
# @eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )
# x = FASTX.description.(synArP)
# @pipe findall(x -> contains(x, "envelope") || contains(x, "syncytin"), x) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> plot
# @pipe findall(x -> contains(x, "envelope") || contains(x, "syncytin"), x) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> scatterplot
# @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400, _) |> getindex(synArP, _) |> FASTX.description.(_)
# l = @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTA.seqlen.(_)
# n = @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)
# n
# barplot(n, l)
# x
# y
# y = readdlm("data/syncytinDB/protein/tmp.csv")
# y = readdlm("data/syncytinDB/protein/tmp.csv", ',')
# n
# y
# y |> size

y = readdlm("data/syncytinDB/protein/tmp.csv", ',')

# y[:, 1]
# n
# contains(y[:, 1], n[1])
# contains.(y[:, 1], n[1])
# findall((y[:, 1], n[1]))
# findall(contains(y[:, 1], n[1]))
# findall.(contains(y[:, 1], n[1]))
# findall(contains.(y[:, 1], n[1]))
# findall(contains.(y[:, 1], n[2]))
# findall(contains.(y[:, 1], n))
# contains.(y[:, 1], n[1])
# map
# map(x -> contains.(y[:, 1], x), n)
# c = map(x -> contains.(y[:, 1], x), n)
# findall(c)
# findall.(c)
# reshape(findall.(c), 150)
# reshape(findall.(c), 150, :)
# map(x -> length(x), findall.(c))
# map(x -> length(x), findall.(c)) |> scatterplot
# findall.(c)
# c = map(x -> contains.(y[:, 1], x), n)
# c = map(x -> findall.(contains.(y[:, 1], x)), n)
# c = map(x -> findall(contains.(y[:, 1], x)), n)
# c = map(x -> contains.(y[:, 1], x), n)
# z = Matrix(150, 150)
# z = zeros(Int64, 150, 150)
# c
# for i in c
# @info i
# end
# enumerate(c)
# iterate(c)
# for i in iterate(c)
# @info i
# end
# for i in enumerate(c)
# @info i
# end
# for (ix, v) in enumerate(c)
# @info i
# end
# for ix, v in enumerate(c)
# @info i
# end
# for i in enumerate(c)
# @info i
# end
# for i in enumerate(c)
# @info i[1]
# end
# for i in enumerate(c)
# @info i[2]
# end
# c[1]
# convert(Int64, c[1])
# convert.(Int64, c[1])
# z = zeros(Int64, 150, 251)
# for v in enumerate(c)
# z[v[1], :] = convert.(Int64, v[2])
# end
# z
# z |> heatmap
# z |> UnicodePlots.heatmap
# z
# z |> sum
# sum
# @pipe z |> sum(_, dims = 2)
# @pipe z |> sum(_, dims = 2) |> scatterplot
# @pipe z |> sum(_, dims = 2)
# @pipe z |> sum(_, dims = 2) |> scatterplot()
# @pipe z |> sum(_, dims = 2) |> scatterplot(_)
# @pipe z |> sum(_, dims = 2) |> scatterplot(_[:, 1])
# @pipe z |> sum(_, dims = 1) |> scatterplot(_[:, 1])
# @pipe z |> sum(_, dims = 1)
# @pipe z |> sum(_, dims = 1) |> scatterplot(_[1, :])
# @pipe z |> sum(_, dims = 1)
# @pipe z |> sum(_, dims = 1) |> findall
# @pipe z |> sum(_, dims = 1) |> findall(_)
# @pipe z |> sum(_, dims = 1) |> findall.(_)
# @pipe z |> sum(_, dims = 1) |> findall.(x -> x > 1, _)
# @pipe z |> sum(_, dims = 1) |> findall(x -> x > 1, _)
# @pipe z |> sum(_, dims = 1) |> findall(x -> x .> 1, _)
# @pipe z |> sum(_, dims = 1)' |> findall(x -> x .> 1, _)
# @pipe z |> sum(_, dims = 1)' |> findall.(x -> x > 1, _)
# @pipe z |> sum(_, dims = 1) |> findall.(x -> x > 1, _[1, :])
# @pipe z |> sum(_, dims = 1) |> findall(x -> x > 1, _[1, :])
# @pipe z |> sum(_, dims = 1) |> findall(x -> x > 1, _[1, :]) |> clipboard
# dups = @pipe z |> sum(_, dims = 1) |> findall(x -> x > 1, _[1, :]) |> clipboard
# synArP[dups]
# synArP
# synArP |> typeof
# synArP[dups]
# dups
# dups = @pipe z |> sum(_, dims = 1) |> findall(x -> x > 1, _[1, :])
# synArP[dups]
# FASTX.sequence
# FASTX.sequence(synArP)
# FASTX.sequence.(synArP)
# FASTX.sequence.(synArP) |> unique
# FASTX.sequence.(synArP[dups]) |> unique
# FASTX.sequence.(synArP[dups]) |> !unique
# FASTX.sequence.(synArP[dups]) |> unique
# FASTX.sequence.(synArP[dups])
# unique
# FASTX.sequence.(synArP[dups]) |> nonunique
# nonunique
# nonunique
# FASTX.sequence.(synArP[dups]) |> unique
# us = FASTX.sequence.(synArP[dups]) |> unique
# FASTX.sequence.(synArP[dups])
# findall(x -> x .== FASTX.sequence.(synArP[dups]), us)
# FASTX.sequence.(synArP[dups])
# FASTX.sequence.(synArP[dups]) .== us
# FASTX.sequence.(synArP[dups]) .== us[1]
# us[1]
# FASTX.sequence.(synArP[dups])
# us[1].data
# us = FASTX.sequence.(synArP[dups]) |> unique
# FASTX.sequence.(synArP[dups])
# FASTX.sequence.(synArP[dups])[1]
# FASTX.sequence.(synArP[dups])[1] == us[1]
# findall(x -> FASTX.sequence.(synArP[dups])[1] == x, us)
# findall(x -> FASTX.sequence.(synArP[dups]) == x, us)
# findall.(x -> FASTX.sequence.(synArP[dups]) == x, us)
# findall(x -> FASTX.sequence.(synArP[dups]) .== x, us)
# findall(x -> FASTX.sequence.(synArP[dups])[1] == x, us)
# ?map
# map
# findall(x -> FASTX.sequence.(synArP[dups])[1] == x, us)
# FASTX.sequence.(synArP[dups])[1] == us[1]
# FASTX.sequence.(synArP[dups])[1] == us
# FASTX.sequence.(synArP[dups]) == us
# FASTX.sequence.(synArP[dups]) .== us
# map(x -> FASTX.sequence.(synArP[dups]) == x, us)
# map(x -> FASTX.sequence.(synArP[dups]) .== x, us)
# for v in enumerate(us)
# @info v
# end
# for v in enumerate(us)
# FASTX.sequence.(synArP[dups]) == v[2]
# end
# for v in enumerate(us)
# @info FASTX.sequence.(synArP[dups]) == v[2]
# end
# for v in enumerate(us)
# @info FASTX.sequence.(synArP[dups]) .== v[2]
# end
# FASTX.sequence.(synArP[dups]) .== us
# FASTX.sequence.(synArP[dups]) == us
# FASTX.sequence.(synArP[dups])[1] == us
# FASTX.sequence.(synArP[dups])[1] .== us
# for v in enumerate(us)
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# @info f[2] == v[2]
# end
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# @info f[2] == v[2]
# end
# println
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# @info f[2] == v[2]
# end
# println()
# end
# us
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# println(f[2] == v[2], f1)
# end
# println()
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# println(f[2] == v[2])
# end
# println()
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# print(f[2] == v[2])
# println(f[1])
# end
# println()
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# print(f[2] == v[2], " ")
# println(f[1])
# end
# println()
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# println(f[1])
# print(f[2] == v[2], " ")
# end
# println()
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# print(f[1], " ")
# println(f[2] == v[2])
# end
# println()
# end
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# print(f[1], "\t")
# println(f[2] == v[2])
# end
# println()
# end
# us
# dups
# dups[12]
# FASTX.sequence.(synArP[dups])
# FASTX.sequence.(synArP[dups[12]])
# dups[12]
# FASTX.sequence.(synArP[dups])
# FASTX.sequence.(synArP[dups[12]])
# FASTX.sequence.(synArP[dups[12:13]])
# FASTX.sequence.(synArP[dups[12:12]])
# (synArP[dups[12:12]])
# synArP[dups[12:12]]
# synArP[dups]
# for v in enumerate(us)
# @info v[1]
# for f in enumerate(FASTX.sequence.(synArP[dups]))
# print(f[1], "\t")
# println(f[2] == v[2])
# end
# println()
# end
# synArP
# synArP[dups]
# @pipe synArP[dups] |> FASTX.identifier
# @pipe synArP[dups] |> FASTX.identifier(_)
# @pipe synArP[dups] .|> FASTX.identifier(_)
# @pipe synArP[dups] .|> FASTX.identifier(_) |> unique
# FASTX.identifier(synArP[1])
# FASTX.identifier(synArP[1]) |> typeof
# Matrix
# FASTX.sequence(synArP[1]) |> typeof
# FASTX.sequence.(synArP)
# function nonunique2(x::AbstractArray{T}) where T
#     xs = sort(x)
#     duplicatedvector = T[]
#     for i=2:length(xs)
#         if (isequal(xs[i],xs[i-1]) && (length(duplicatedvector)==0 || !isequal(duplicatedvector[end], xs[i])))
#             push!(duplicatedvector,xs[i])
#         end
#     end
#     duplicatedvector
# end
# nonunique2(1:10)
# nonunique2(repeat([10], 3))
# us
# dups
# FASTX.sequence.(synArP)
# FASTX.sequence.(synArP) |> nonunique2
# us
# FASTX.sequence.(synArP[dups]) |> nonunique2
# FASTX.sequence.(synArP[dups])
# function nonunique2(x::AbstractArray{T}) where T
#     xs = sort(x)
#     duplicatedvector = T[]
#     for i=2:length(xs)
#         if (isequal(xs[i],xs[i-1]) && (length(duplicatedvector)==0 || !isequal(duplicatedvector[end], xs[i])))
#           println(i)
#             push!(duplicatedvector,xs[i])
#         end
#     end
#     duplicatedvector
# end
# FASTX.sequence.(synArP[dups]) |> nonunique2
# FASTX.sequence.(synArP[dups])[2]
# FASTX.sequence.(synArP[dups])[6]
# sdup = FASTX.sequence.(synArP[dups])
# sdup[2]
# sdup[2] .== sdup
# findall(x -> sdup[2] == x, sdup)
# sdup
# findall(x -> x == sdup, sdup)
# findall.(x -> x == sdup, sdup)
# findall(x -> x == sdup[2, sdup)
# findall(x -> x == sdup[2], sdup)
# findall(x -> x == sdup[26], sdup)
# for i in 1:26
# @info findall(x -> x == sdup[i], sdup)
# end
# sdup[22:24]
# synArP[dups]
# synArP[dups][22:24]
# for i in 1:26
# @info findall(x -> x == sdup[i], sdup)
# end
# for i in 1:26
# @info synArP[dups][findall(x -> x == sdup[i], sdup)]
# end
# for i in 1:26
# @info synArP[dups][findall(x -> x == sdup[i], sdup)]
# println(
# end
# for i in 1:26
# @info synArP[dups][findall(x -> x == sdup[i], sdup)]
# println()
# end
# registerVc = FASTX.sequence.(synArP)
# registerVc |> unique
# for i in 1:26
# @info synArP[dups][findall(x -> x == sdup[i], sdup)]
# println()
# end
# function uq(x::AbstractArray{T}) where T
#     xs = sort(x)
#     duplicatedvector = T[]
#     for i in 2:length(xs)
#         if (!isequal(xs[i], xs[i - 1]) && (length(duplicatedvector) == 0 || !isequal(duplicatedvector[end], xs[i])))
#             push!(duplicatedvector, xs[i])
#         end
#     end
#     duplicatedvector
# end
# @pipe synArP[dups] .|> FASTX.identifier(_) |> unique
# sdup
# synArP[dups]
# synArP[dups] |> unique
# @pipe synArP[dups] .|> FASTX.identifier(_) |> unique
# findfirst.([x], unique(x))
# x
# findfirst.([x], unique(x))
# unique(x)
# findfirst.(isequal.(unique(x)), [x])
# d
# y
# z
# sdup
# findfirst.(isequal.(unique(sdup)), [sdup])
# sdup[findfirst.(isequal.(unique(sdup)), [sdup])]
# sdup[findfirst.(isequal.(unique(sdup)), [sdup])] .== unique(sdup)
# sdup[findfirst.(isequal.(unique(sdup)), [sdup])] == unique(sdup)
# function uniqueidx(x::AbstractArray{T}) where T
#     uniqueset = Set{T}()
#     ex = eachindex(x)
#     idxs = Vector{eltype(ex)}()
#     for i in ex
#         xi = x[i]
#         if !(xi in uniqueset)
#             push!(idxs, i)
#             push!(uniqueset, xi)
#         end
#     end
#     idxs
# end
# uniqueidx(sdup)
# "select non unique elements"
# function nunique(x::AbstractArray{T}) where T
#     xs = sort(x)
#     duplicatedvector = T[]
#     for i in 2:length(xs)
#         if (isequal(xs[i], xs[i - 1]) && (length(duplicatedvector) == 0 || !isequal(duplicatedvector[end], xs[i])))
#             push!(duplicatedvector, xs[i])
#         end
#     end
#     duplicatedvector
# end
# "select unique element indexes"
# function uniqueix(x::AbstractArray{T}) where T
#     uniqueset = Set{T}()
#     ex = eachindex(x)
#     ixs = Vector{eltype(ex)}()
#     for i in ex
#         xi = x[i]
#         if !(xi in uniqueset)
#             push!(ixs, i)
#             push!(uniqueset, xi)
#         end
#     end
#     ixs
# end
# "purge duplicate sequences"
# function purgeSequences(synAr::Vector{FASTX.FASTA.Record})
#   registerVc = FASTX.sequence.(synAr)
#   registerIx = uniqueix(registerVc)
#   return synAr[registerIx]
# end
# synArP
# synArP[dups]
# synArP[dups] |> purgeSequences
# n
# l
# ds
# @pipe findall(x -> contains(x, "envelope") || contains(x, "syncytin"), x) |> getindex(synArP, _) |> FASTA.seqlen.(_) |> scatterplot
# x
# n = @pipe synArP |> findall(x -> FASTA.seqlen(x) >= 400 && (contains(FASTX.description(x), "syncytin") || contains(FASTX.description(x), "envelope")), _) |> getindex(synArP, _) |> FASTX.description.(_)
# z
# y
# @pipe y |> findall(x -> (contains(x, "syncytin") || contains(x, "envelope")), _)

w = @pipe y[:, 1] |> findall(x -> (contains(x, "syncytin") || contains(x, "envelope")), _)

# n
# writedlm()
# writedlm("data/syncytinDB/protein/curTmp.csv", ',', w)
# writedlm("data/syncytinDB/protein/curTmp.csv", w)
# w
# writedlm("data/syncytinDB/protein/curTmp.csv", synArP[w])

writedlm("data/syncytinDB/protein/curTmp.csv", y[w])

# a = readdlm("data/syncytinDB/protein/curTmp.csv", ',')
# findall(x -> x == "", a[:, 2])
# a = readdlm("data/syncytinDB/protein/curTmp.csv", ',')
# findall(x -> x == "", a[:, 2])
# synArP
# synArP[170]
# synArP[170:179]
# synArP[169]

a = readdlm("data/syncytinDB/protein/curTmp.csv", ',')
findall(x -> x == "", a[:, 2])
using FreqTables
a[:, 2] |> freqtable

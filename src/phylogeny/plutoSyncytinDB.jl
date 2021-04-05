
# load packages
begin

  using Distances
  using BioAlignments
  using BioSequences
  using FASTX

  using Clustering
  using StatsPlots
  using CSV
  using DataFrames

end;

# load syncytin library
begin

  # declare empty array
  synArr = Array{FASTX.FASTA.Record}(undef, 1)

  # read sequences from file
  syncytinDir = "/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/"
  syncytinDB = "syncytinLibrary.fasta"
  reader = FASTA.Reader(open( string(syncytinDir, syncytinDB), "r"))
  ct = 0

  # extract sequences from reader
  for record in reader
    ct += 1
    if ct == 1
      synArr[1] = record
    else
      push!(synArr, record)
    end
  end
  close(reader)

  # group syncytin sequences
  synGroupDf = CSV.read("/Users/drivas/Factorem/Syncytin/data/syncytinDB/syncytinGroups.csv", DataFrame, header = false)

end;

# construct arrays
begin

  # construct array
  synLen = length(synArr)
  levArr = zeros(Float64, synLen, synLen)

  # sequence length array
  lenArr = Array{Any, 2}(nothing, synLen, 2)

end;

# plot sequence length
begin

  # sequence length
  lenArr[:, 1] .= FASTA.seqlen.(synArr)

  # tag groups
  for ix in 1:size(synGroupDf, 1)
    lenArr[contains.(description.(synArr), synGroupDf[ix, 1]), 2] .= ix
  end

  # retag non-syncytin grouped
  lenArr[isnothing.(lenArr[:, 2]), 2] .= size(synGroupDf, 1) + 1

  # # declare layout
  # gr()
  # ly = @layout [a{0.001h};b c{0.50w}]

  # p0 = plot(title = "SyncytinDB", grid = false, showaxis = false)

  # prepare canvas
  # p1 = plot(xlims = (0, 250), ylims = (0, 1800), legend = :none)
  # p2 = plot(grid = false, showaxis = false)
  plen = plot(
    xlims = (0, size(lenArr, 1)),
    ylims = (0, maximum(lenArr[:, 1])),
    xlabel = "Syncytin sequence",
    ylabel = "Sequence length",
    xticks = false,
    legend = :outertopright,
  )

  # plot groups
  for ix in 1:size(synGroupDf, 1) + 1
    cpLenArr = copy(lenArr)
    cpLenArr[findall(x -> x != ix, cpLenArr[:, 2]), 1] .= 0
    if ix == 14
      # bar!(p1, cpLenArr[:, 1])
      # bar!(p2, cpLenArr[:, 1], label = "Unassigned")
      bar!(plen, cpLenArr[:, 1], label = "Unassigned") |> display
    else
      # bar!(p1, cpLenArr[:, 1])
      # bar!(p2, cpLenArr[:, 1], label = synGroupDf[ix, 2])
      bar!(plen, cpLenArr[:, 1], label = synGroupDf[ix, 2]) |> display
    end
  end

  # plot(p0, p1, p2, layout = ly) |> display

  plen

end

# calculate levenshtein distances proteins
for ix in 1:synLen
  for jx in 1:synLen
    seq1 = sequence(synArr[ix])
    seq2 = sequence(synArr[jx])
    levArr[ix, jx] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
  end
end;

# build hierarchical clustering
begin
  hc = hclust(levArr, linkage = :average, branchorder = :optimal)
end;

# plot distances & clustering
begin
  ly = grid(2, 2, heights = [0.2, 0.8, 0.2, 0.8], widths = [0.8, 0.2, 0.8, 0.2])
  phc = plot(
    plot(hc, ylims = (0, 30), xticks = false),
    plot(tikcs = nothing, border = :none),
    heatmap(levArr[hc.order, hc.order], colorbar = false, ),
    plot(hc, xlims = (0, 30), yticks = false, xrotation = 90, orientation = :horizontal),
    layout = ly,
  )

  phc

end

# recalculate without unassigned sequences
begin
  # purge unassigned sequences
  sGr = lenArr[:, 2] .!= 14
  purLevArr = levArr[sGr, sGr]

  # recalculate hierarchical clustering
  purHc = hclust(purLevArr, linkage = :average, branchorder = :optimal)

  # re plot
  lp = grid(2, 2, heights = [0.2, 0.8, 0.2, 0.8], widths = [0.8, 0.2, 0.8, 0.2])
  pphc = plot(
    plot(purHc, ylims = (0, 35), xticks = false),
    plot(ticks = nothing, border = :none),
    heatmap(purLevArr[purHc.order, purHc.order], colorbar = false, ),
    plot(purHc, xlims = (0, 35), yticks = false, xrotation = 90, orientation = :horizontal),
    layout = lp,
  )

  pphc

end

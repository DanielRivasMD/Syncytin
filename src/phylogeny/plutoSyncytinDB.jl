
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
    xlims = (0, size(lenArr, 1) + 1),
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

# plot trimmed sequence length
begin

  # trim unassigned group
  unGr = lenArr[:, 2] .!= 14
  purLenArr = lenArr[unGr, :]

  # prepare canvas
  # p1 = plot(xlims = (0, 250), ylims = (0, 1800), legend = :none)
  # p2 = plot(grid = false, showaxis = false)
  pplen = plot(
    xlims = (0, size(purLenArr, 1) + 1),
    ylims = (0, maximum(purLenArr[:, 1])),
    xlabel = "Syncytin sequence",
    ylabel = "Sequence length",
    xticks = false,
    legend = :outertopright,
  )

  # plot groups
  for ix in 1:size(synGroupDf, 1)
    cpLenArr = copy(purLenArr)
    cpLenArr[findall(x -> x != ix, cpLenArr[:, 2]), 1] .= 0
    # bar!(p1, cpLenArr[:, 1])
    # bar!(p2, cpLenArr[:, 1], label = synGroupDf[ix, 2])
    bar!(pplen, cpLenArr[:, 1], label = synGroupDf[ix, 2]) |> display
  end

  # plot(p0, p1, p2, layout = ly) |> display

  pplen

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
  ly = @layout [[a; b{0.1h}] c{0.1w}; d{0.8w} e{0.05w} f]
  # ly = grid(3, 3, heights = [0.2, 0.02, 0.78, 0.2, 0.02, 0.78, 0.2, 0.02, 0.78], widths = [0.78, 0.02, 0.2, 0.78, 0.02, 0.2, 0.78, 0.02, 0.2])
  phc = plot(

    plot(hc, ylims = (0, 30), xticks = false),
    # plot(tikcs = nothing, border = :none),
    # plot(tikcs = nothing, border = :none),

    heatmap(reshape(lenArr[hc.order, 2], (1, size(lenArr, 1))), colorbar = false, ticks = false, fillcolor = :roma, ),
    # plot(tikcs = nothing, border = :none),
    # plot(tikcs = nothing, border = :none),

    heatmap([""], [synGroupDf[:, 2]; "Unassigned"], reshape([synGroupDf[:, 2]; "Unassigned"], (size(synGroupDf, 1) + 1, 1)), fillcolor = :roma, colorbar = false, xticks = false, yflip = true, ),

    heatmap(levArr[hc.order, hc.order], colorbar = false, fillcolor = :balance, ),
    heatmap(reshape(lenArr[hc.order, 2], (size(lenArr, 1), 1)), colorbar = false, ticks = false, fillcolor = :roma, ),
    plot(hc, xlims = (0, 30), yticks = false, xrotation = 90, orientation = :horizontal, ),

    layout = ly,
  )

  phc

end

# recalculate without unassigned sequences
begin
  # purge unassigned sequences
  ugGr = lenArr[:, 2] .!= 14
  purLevArr = levArr[ugGr, ugGr]

  # recalculate hierarchical clustering
  purHc = hclust(purLevArr, linkage = :average, branchorder = :optimal)

  # re plot
  lp = @layout [[a; b{0.1h}] c{0.1w}; d{0.8w} e{0.05w} f]
  # lp = grid(3, 3, heights = [0.2, 0.02, 0.78, 0.01, 0.21, 0.78, 0.01, 0.21, 0.78], widths = [0.78, 0.21, 0.01, 0.78, 0.21, 0.01, 0.78, 0.02, 0.2])
  pphc = plot(

    plot(purHc, ylims = (0, 35), xticks = false),
    # plot(ticks = nothing, border = :none),

    heatmap(reshape(purLenArr[purHc.order, 2], (1, size(purLenArr, 1))), colorbar = false, ticks = false, fillcolor = :roma, ),
    heatmap([""], synGroupDf[:, 2], reshape(synGroupDf[:, 2], (size(synGroupDf, 1), 1)), fillcolor = :roma, colorbar = false, xticks = false, yflip = true, ),
    # plot(tikcs = nothing, border = :none),
    # plot(tikcs = nothing, border = :none),

    heatmap(purLevArr[purHc.order, purHc.order], colorbar = false, fillcolor = :balance, ),
    heatmap(reshape(purLenArr[purHc.order, 2], (size(purLenArr, 1), 1)), colorbar = false, ticks = false, fillcolor = :roma, ),
    plot(purHc, xlims = (0, 35), yticks = false, xrotation = 90, orientation = :horizontal, ),

    layout = lp,
  )

  pphc

end

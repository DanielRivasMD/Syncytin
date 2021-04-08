################################################################################

# load packages
begin

  using Pkg
  Pkg.activate("/Users/drivas/Factorem/Syncytin/")

  using Distances
  using BioAlignments
  using BioSequences
  using FASTX

  using Clustering
  using StatsPlots
  using CSV
  using DataFrames
end;

################################################################################

# load syncytin library
function syncytinReader(; synDB::String, synDir::String)

  # declare empty array
  synOutArr = Array{FASTX.FASTA.Record}(undef, 1)

  let ct = 0
    reader = FASTA.Reader(open( string(synDir, synDB), "r"))

    # extract sequences from reader
    for record in reader
      ct += 1
      if ct == 1
        synOutArr[1] = record
      else
        push!(synOutArr, record)
      end
    end
    close(reader)
  end

  return synOutArr
end

# group syncytin sequences
function syncytinGroupReader(; synG)
  return CSV.read(synG, DataFrame, header = false)
end

################################################################################

# calculate levenshtein distances
function levenshteinDist(synAr::Vector{FASTX.FASTA.Record})

  # construct array
  synLen = length(synAr)
  outLevAr = zeros(Float64, synLen, synLen)

  for ix in 1:synLen
    seq1 = FASTX.sequence(synAr[ix])
    for jx in 1:synLen
      if ( ix == jx ) continue end # omit diagonal

      # use memoization
      if outLevAr[jx, ix] != 0
        outLevAr[ix, jx] = outLevAr[jx, ix]
      else
        seq2 = FASTX.sequence(synAr[jx])
        outLevAr[ix, jx] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
     end

    end
  end

  return outLevAr
end

# build hierarchical clustering
function levHClust(levAr::Matrix{Float64})
  return Clustering.hclust(levAr, linkage = :average, branchorder = :optimal)
end

# build array
function buildLen(synAr::Vector{FASTX.FASTA.Record}, syngDf::DataFrame)

  # contruct array
  synLen = length(synAr)

  # sequence length array
  lenAr = Array{Any, 2}(nothing, synLen, 2)

  # sequence length
  lenAr[:, 1] .= FASTA.seqlen.(synAr)

  # tag groups
  for ix in 1:size(syngDf, 1)
    lenAr[contains.(description.(synAr), syngDf[ix, 1]), 2] .= ix
  end

  # retag non-syncytin grouped
  lenAr[isnothing.(lenAr[:, 2]), 2] .= size(syngDf, 1) + 1

  return lenAr
end

################################################################################

# plot sequence length
function synLenPlot(synAr::Vector{FASTX.FASTA.Record}, syngDf::DataFrame; trim::Bool = false)

  lenAr = buildLen(synAr, syngDf)

  # trim unassigned group
  if trim
    lenAr = lenAr[lenAr[:, 2] .!= 14, :]
    syngLen = size(syngDf, 1)
  else
    syngLen = size(syngDf, 1) + 1
  end

  # prepare canvas
  p = StatsPlots.plot(
    xlims = (0, size(lenAr, 1) + 1),
    ylims = (0, maximum(lenAr[:, 1])),
    xlabel = "Syncytin sequence",
    ylabel = "Sequence length",
    xticks = false,
    legend = :outertopright,
    dpi = 300,
  )

  # plot groups
  for ix in 1:syngLen
    cpLenAr = copy(lenAr)
    cpLenAr[findall(x -> x != ix, cpLenAr[:, 2]), 1] .= 0
    if ix == 14
      StatsPlots.bar!(p, cpLenAr[:, 1], label = "Unassigned", lw = 0, )
    else
      StatsPlots.bar!(p, cpLenAr[:, 1], label = syngDf[ix, 2], lw = 0, )
    end
  end

  p
end

# plot distances & clustering
function synLevHCPlot(levAr::Matrix{Float64}, syngDf::DataFrame; trim::Bool = false, lenAr = Array)

#  BUG: colorbars are the wrong color
  # purge unassigned sequences
  if trim
    ua = lenAr[:, 2] .!= 14
    levAr = levAr[ua, ua]

    syngLen = size(syngDf, 1)
    annotBar = syngDf[:, 2]
  else
    syngLen = size(syngDf, 1) + 1
    annotBar = [syngDf[:, 2]; "Unassigned"]
  end

  # build hierarchical clustering
  synHC = levHClust(levAr)

  # layout
  ly = @layout [[a; b{0.1h}] c{0.1w}; d{0.8w} e{0.05w} f]
  p = StatsPlots.plot(

    # top dendrogram
    StatsPlots.plot(synHC, ylims = (0, 30), xticks = false),

    # top group bar
    StatsPlots.heatmap(reshape(levAr[synHC.order, 2], (1, size(levAr, 1))), colorbar = false, ticks = false, fillcolor = :roma, ),

    # group annotations
    StatsPlots.heatmap([""], annotBar, reshape(annotBar, (syngLen, 1)), fillcolor = :roma, colorbar = false, xticks = false, yflip = true, ),

    # ordered distance matrix
    StatsPlots.heatmap(levAr[synHC.order, synHC.order], colorbar = false, fillcolor = :balance, ),

    # right group bar
    StatsPlots.heatmap(reshape(levAr[synHC.order, 2], (size(levAr, 1), 1)), colorbar = false, ticks = false, fillcolor = :roma, ),

    # right dendrogram
    StatsPlots.plot(synHC, xlims = (0, 30), yticks = false, xrotation = 90, orientation = :horizontal, ),

    layout = ly,
    dpi = 300,
  )

  p
end

################################################################################

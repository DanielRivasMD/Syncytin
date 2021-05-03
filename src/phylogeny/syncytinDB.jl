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

"read `fasta` syncytin library file to array"
function syncytinReader(synDB::String)

  # declare empty array
  synOutArr = Array{FASTX.FASTA.Record}(undef, 1)

  let ct = 0
    reader = FASTA.Reader(open(synDB, "r"))

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

"read `csv` syncytin groups file to array"
function syncytinGroupReader(synG::String)
  return CSV.read(synG, DataFrame, header = false)
end

"write `fasta` file from array"
function syncytinWriter(synFA::String, synAr::Vector{FASTX.FASTA.Record})

  # loop over array
  open(FASTA.Writer, synFA) do w
    for rc in synAr
      write(w, FASTA.Record(FASTX.identifier(synAr[1]), FASTX.description(synAr[1]), FASTX.sequence(synAr[1])))
    end
  end
end

################################################################################

"calculate levenshtein distances"
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

"build hierarchical clustering"
function levHClust(levAr::Matrix{Float64})
  return Clustering.hclust(levAr, linkage = :average, branchorder = :optimal)
end

"build sequence length array"
function buildLen(synAr::Vector{FASTX.FASTA.Record})

  # sequence length
  lenAr = FASTA.seqlen.(synAr)

  return lenAr
end

################################################################################

"select non unique elements"
function nunique(x::AbstractArray{T}) where T
  xs = sort(x)
  duplicatedvector = T[]
  for i in 2:length(xs)
    if (isequal(xs[i], xs[i - 1]) && (length(duplicatedvector) == 0 || !isequal(duplicatedvector[end], xs[i])))
      push!(duplicatedvector, xs[i])
    end
  end
  duplicatedvector
end

"select unique element indexes"
function uniqueix(x::AbstractArray{T}) where T
  uniqueset = Set{T}()
  ex = eachindex(x)
  ixs = Vector{eltype(ex)}()
  for i in ex
    xi = x[i]
    if !(xi in uniqueset)
      push!(ixs, i)
      push!(uniqueset, xi)
    end
  end
  ixs
end

"purge records by duplicated sequence"
function purgeSequences(synAr::Vector{FASTX.FASTA.Record})
  registerVc = FASTX.sequence.(synAr)
  registerIx = uniqueix(registerVc)
  return synAr[registerIx]
end

################################################################################

"create tag group vector"
function tagGroup(synAr::Vector{FASTX.FASTA.Record}, syngDf::DataFrame)

  # contruct array
  synLen = length(synAr)

  # sequence length array
  tagAr = zeros(Int64, synLen)

  # tag groups
  for ix in 1:size(syngDf, 1)
    tagAr[contains.(description.(synAr), syngDf[ix, 1]), 1] .= ix
  end

  # retag non-syncytin grouped
  tagAr[tagAr .== 0] .= size(syngDf, 1) + 1

  return tagAr
end

"trim matrix based on vector"
function trimmer!(douAr::Matrix, trimVc::BitVector)
  return douAr[trimVc, trimVc]
end

"trim array based on vector"
function trimmer!(unAr::Vector, trimVc::BitVector)
  return unAr[trimVc]
end

################################################################################

"plot sequence length"
function synLenPlot(synAr::Vector{FASTX.FASTA.Record}, syngDf::DataFrame; trim::Bool = false)

  lenAr = buildLen(synAr)

  tagAr = tagGroup(synAr, syngDf)

  # trim unassigned group
  if trim
    lenAr = trimmer!(lenAr, tagAr .!= size(syngDf, 1) + 1)
    tagAr = trimmer!(tagAr, tagAr .!= size(syngDf, 1) + 1)
    syngLen = size(syngDf, 1)
  else
    syngLen = size(syngDf, 1) + 1
  end

  # prepare canvas
  p = StatsPlots.plot(
    xlims = (0, size(lenAr, 1) + 1),
    ylims = (0, maximum(lenAr)),
    xlabel = "Syncytin sequence",
    ylabel = "Sequence length",
    xticks = false,
    legend = :outertopright,
    dpi = 300,
  )

  # plot groups
  for ix in 1:syngLen
    cpLenAr = copy(lenAr)
    cpLenAr[findall(x -> x != ix, tagAr), 1] .= 0
    if ix == size(syngDf, 1) + 1
      StatsPlots.bar!(p, cpLenAr, label = "Unassigned", lw = 0)
    else
      StatsPlots.bar!(p, cpLenAr, label = syngDf[ix, 2], lw = 0)
    end
  end

  p
end

"plot distances & clustering"
function synLevHCPlot(levAr::Matrix{Float64}, syngDf::DataFrame, synAr::Vector{FASTX.FASTA.Record}; trim::Bool = false)

  tagAr = tagGroup(synAr, syngDf)

  # purge unassigned sequences
  if trim

    ua = tagAr .!= size(syngDf, 1) + 1

    levAr = trimmer!(levAr, ua)

    tagAr = trimmer!(tagAr, ua)

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
    StatsPlots.heatmap(reshape(tagAr[synHC.order], (1, length(tagAr))), colorbar = false, ticks = false, fillcolor = :roma),

    # group annotations
    StatsPlots.heatmap([""], annotBar, reshape(annotBar, (syngLen, 1)), fillcolor = :roma, colorbar = false, xticks = false, yflip = true),

    # ordered distance matrix
    StatsPlots.heatmap(levAr[synHC.order, synHC.order], colorbar = false, fillcolor = :balance),

    # right group bar
    StatsPlots.heatmap(reshape(tagAr[synHC.order], (length(tagAr), 1)), colorbar = false, ticks = false, fillcolor = :roma),

    # right dendrogram
    StatsPlots.plot(synHC, xlims = (0, 30), yticks = false, xrotation = 90, orientation = :horizontal),

    layout = ly,
    dpi = 300,
  )

  p
end

################################################################################

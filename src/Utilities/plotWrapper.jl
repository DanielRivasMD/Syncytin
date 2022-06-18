################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string(projDir, "/Project.toml")
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  using StatsPlots

  using FASTX
end;

################################################################################

# load modules
begin
end;

################################################################################

"plot sequence length"
function syncytinLenPlot(fastaAr::Vector{FASTX.FASTA.Record}, groupDf::DataFrame; trim::Bool = false)

  lenAr = buildLen(fastaAr)

  tagAr = tagGroup(fastaAr, groupDf)

  # trim unassigned group
  if trim
    lenAr = trimmer!(lenAr, tagAr .!= size(groupDf, 1) + 1)
    tagAr = trimmer!(tagAr, tagAr .!= size(groupDf, 1) + 1)
    groupLen = size(groupDf, 1)
  else
    groupLen = size(groupDf, 1) + 1
  end

  # prepare canvas
  φ = StatsPlots.plot(
    xlims = (0, size(lenAr, 1) + 1),
    ylims = (0, maximum(lenAr)),
    xlabel = "Syncytin sequence",
    ylabel = "Sequence length",
    xticks = false,
    legend = :outertopright,
    dpi = 300,
  )

  # plot groups
  for ι ∈ eachindex(groupLen)
    cpLenAr = copy(lenAr)
    cpLenAr[findall(χ -> χ != ι, tagAr), 1] .= 0
    if ι == size(groupDf, 1) + 1
      StatsPlots.bar!(p, cpLenAr, label = "Unassigned", lw = 0)
    else
      StatsPlots.bar!(p, cpLenAr, label = groupDf[ι, 2], lw = 0)
    end
  end

  φ
end

"plot distances & clustering"
function syncytinLevHPlot(levAr::Matrix{Float64}, groupDf::DataFrame, fastaAr::Vector{FASTX.FASTA.Record}; trim::Bool = false)

  tagAr = tagGroup(fastaAr, groupDf)

  # purge unassigned sequences
  if trim

    ua = tagAr .!= size(groupDf, 1) + 1

    levAr = trimmer!(levAr, ua)

    tagAr = trimmer!(tagAr, ua)

    groupLen = size(groupDf, 1)
    annotBar = groupDf[:, 2]
  else
    groupLen = size(groupDf, 1) + 1
    annotBar = [groupDf[:, 2]; "Unassigned"]
  end

  # build hierarchical clustering
  syncytinHC = levHClust(levAr)

  # layout
  λ = @layout [[a; b{0.1h}] c{0.1w}; d{0.8w} e{0.05w} f]
  φ = StatsPlots.plot(

    # top dendrogram
    StatsPlots.plot(syncytinHC, ylims = (0, 30), xticks = false),

    # top group bar
    StatsPlots.heatmap(reshape(tagAr[syncytinHC.order], (1, length(tagAr))), colorbar = false, ticks = false, fillcolor = :roma),

    # group annotations
    StatsPlots.heatmap([""], annotBar, reshape(annotBar, (groupLen, 1)), fillcolor = :roma, colorbar = false, xticks = false, yflip = true),

    # ordered distance matrix
    StatsPlots.heatmap(levAr[syncytinHC.order, syncytinHC.order], colorbar = false, fillcolor = :balance),

    # right group bar
    StatsPlots.heatmap(reshape(tagAr[syncytinHC.order], (length(tagAr), 1)), colorbar = false, ticks = false, fillcolor = :roma),

    # right dendrogram
    StatsPlots.plot(syncytinHC, xlims = (0, 30), yticks = false, xrotation = 90, orientation = :horizontal),

    layout = λ,
    dpi = 300,
  )

  φ
end

################################################################################

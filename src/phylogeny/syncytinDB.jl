################################################################################

using Distances
using BioAlignments
using BioSequences

using Clustering
using StatsPlots

################################################################################

# declare empty array
synArr = Array{FASTX.FASTA.Record}(undef, 1)

# read sequences from file
syncytinDir = "data/syncytinDB/protein/"
syncytinDB = "syncytinLibrary.fasta"

reader = FASTA.Reader(open( string(syncytinDir, syncytinDB), "r"))
ct = 0

for record in reader
  # extract sequences from reader
  ct += 1
  if ct == 1
    @info "first iteration"
    @info record
    synArr[1] = record
  else
    @info "plus iteration"
    push!(synArr, record)
  end
end
close(reader)

# construct array
synLen = length(synArr)
levArr = zeros(Int64, synLen, synLen)

# calculate levenshtein distances
for ix in 1:synLen
  for jx in 1:synLen
    levArr[ix, jx] = BioSequences.sequencelevenshtein_distance(sequence(synArr[ix]), sequence(synArr[jx]))
  end
end

# build hierarchical clustering
hc = hclust(levArr, linkage = :average, branchorder = :optimal)

# plot
ly = grid(2, 2, heights = [0.2, 0.8, 0.2, 0.8], widths = [0.8, 0.2, 0.8, 0.2])
p = plot(
  plot(hc, ylims = (0, 200), xticks = false),
  plot(tikcs = nothing, border = :none),
  heatmap(levArr[hc.order, hc.order], colorbar = false, ),
  plot(hc, xlims = (0, 200), yticks = false, xrotation = 90, orientation = :horizontal),
  layout = ly,
)

# blast sequences against HiC alignemnts
# retrieve chromosomal coordinates
# run satsuma on neighboring sequences

################################################################################

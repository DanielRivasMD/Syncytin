################################################################################

# declarations
begin
  include( "/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl" )
end;

################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string( projDir, "/Project.toml" )
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  using BioSequences
  using Clustering
  using FASTX
end;

################################################################################

# load modules
begin
end;

################################################################################

"calculate levenshtein distances"
function levenshteinDist(fastaAr::Vector{FASTX.FASTA.Record})

  # construct array
  fastaLen = length(fastaAr)
  outLevAr = zeros(Float64, fastaLen, fastaLen)

  for ι ∈ eachindex(fastaLen)
    seq1 = FASTX.sequence(fastaAr[ι])
    for ο ∈ eachindex(fastaLen)
      # omit diagonal
      if ( ι == ο ) continue end

      # use memoization
      if outLevAr[ο, ι] != 0
        outLevAr[ι, ο] = outLevAr[ο, ι]
      else
        seq2 = FASTX.sequence(fastaAr[ο])
        outLevAr[ι, ο] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
     end

    end
  end

  return outLevAr
end

"build hierarchical clustering"
function levHClust(levAr::Matrix{Float64})
  return Clustering.hclust(levAr, linkage = :average, branchorder = :optimal)
end

################################################################################

"return best position (highest identity percentage) on alignment"
function bestPosition(df::DataFrame)
  #  TODO: alternatively, find minimum e-value
  #  TODO: round start & end positions
  return combine(groupby(df, [:QueryAccession, :QueryStart, :QueryEnd])) do χ
    χ[argmax(χ.SequenceIdentity), :]
  end
end

################################################################################

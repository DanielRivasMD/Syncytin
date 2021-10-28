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
  using FASTX
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/arrayOperations.jl" ))
end;

################################################################################

"build sequence length array"
function buildLen(fastaAr::Vector{FASTX.FASTA.Record})
  return FASTA.seqlen.(fastaAr)
end

################################################################################

"purge records by duplicated sequence"
function purgeSequences(fastaAr::Vector{FASTX.FASTA.Record})
  registerVc = FASTX.sequence.(fastaAr)
  registerIx = uniqueix(registerVc)
  return fastaAr[registerIx]
end

################################################################################

"create tag group vector"
function tagGroup(fastaAr::Vector{FASTX.FASTA.Record}, groupDf::DataFrame)

  # contruct array
  syncytinLen = length(fastaAr)

  # sequence length array
  tagAr = zeros(Int64, syncytinLen)

  # tag groups
  for ι ∈ 1:size(groupDf, 1)
    tagAr[contains.(description.(fastaAr), groupDf[ι, 1]), 1] .= ι
  end

  # retag non-syncytin grouped
  tagAr[tagAr .== 0] .= size(groupDf, 1) + 1

  return tagAr
end

################################################################################

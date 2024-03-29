####################################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

####################################################################################################

# load packages
begin
  using BioSequences
  using FASTX
end;

####################################################################################################

# load modules
begin
  include(string(utilDir, "/arrayOperations.jl"))
end;

####################################################################################################

"build sequence length array"
function buildLen(fastaAr::V{FsR}) where V <: Vector where FsR <: FASTX.FASTA.Record
  return FASTA.seqlen.(fastaAr)
end

####################################################################################################

"purge records by duplicated sequence"
function purgeSequences(fastaAr::V{FsR}) where V <: Vector where FsR <: FASTX.FASTA.Record
  registerVc = FASTX.sequence.(fastaAr)
  registerIx = uniqueix(registerVc)
  return fastaAr[registerIx]
end

####################################################################################################

"create tag group vector"
function tagGroup(fastaAr::V{FsR}, gdf::Df) where V <: Vector where FsR <: FASTX.FASTA.Record where Df <: DataFrame

  # contruct array
  syncytinLen = length(fastaAr)

  # sequence length array
  tagAr = zeros(Int64, syncytinLen)

  # tag groups
  for ι ∈ 1:size(gdf, 1)
    tagAr[contains.(description.(fastaAr), gdf[ι, 1]), 1] .= ι
  end

  # retag non-syncytin grouped
  tagAr[tagAr .== 0] .= size(gdf, 1) + 1

  return tagAr
end

####################################################################################################

"translate array safely"
function translateRecord(fastaAr::V{FsR}) where V <: Vector where FsR <: FASTX.FASTA.Record
  Ω = Vector{FASTX.FASTA.Record}(undef, 0)
  for υ ∈ fastaAr
    δ = split(FASTX.description(υ), " ")
    rseq = begin
      dseq = if δ[end] == "+"
        FASTX.sequence(υ)
      elseif δ[end] == "-"
        BioSequences.reverse_complement(FASTX.sequence(υ))
      else
        @error "Strand was not defined as expected" δ[end]
      end
      Υ = length(dseq) % 3
      BioSequences.translate(dseq[1:end - Υ])
    end
    push!(Ω, FASTA.Record(FASTX.identifier(υ), FASTX.description(υ), rseq))
  end
  return Ω
end

####################################################################################################

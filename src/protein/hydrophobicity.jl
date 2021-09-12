################################################################################

using DelimitedFiles
using DataFrames

################################################################################

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

################################################################################

function calculateHydropathy(record, hydro)
  # contrusct empty score vector
  score = Array{Float64, 1}(undef, 0)
  # collect aminoacid values
  for aa in record |> FASTX.sequence
    push!(score, findfirst(χ -> χ == aa, hydro.OneLetterCode) |> π -> hydro[π, :HydropathyScore])
  end
  return score
end

function windowSlide(score, bin = 9, weight = repeat([1.], 9))
  # contruct vector
  sliced = Array{Float64, 1}(undef, 0)
  # iterate on vector
  for ι ∈ 1:length(score)
    # do not overshoot vector boundries
    ω = ι + bin - 1
    if ω > length(score)
      break
    end
    # calculate bin average
    push!(sliced, sum(score[ι:ω] .* weight) / bin)
  end
  return sliced
end

################################################################################

# load hydrophobicity values
hydro = @chain begin
  readdlm("src/protein/hydrophobicity.tsv")
  DataFrame(_, :auto)
  rename!(_, ["AminoAcid", "OneLetterCode", "HydropathyScore"])
end

# cast columns
begin
  hydro.AminoAcid = map(χ -> convert(String, χ), hydro.AminoAcid)
  hydro.OneLetterCode = map(χ -> AminoAcid(collect(χ)[end]), hydro.OneLetterCode)
  hydro.HydropathyScore = map(χ -> convert(Float64, χ), hydro.HydropathyScore)
end

################################################################################

# load protein database
synAr = syncytinReader("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/CURATEDsyncytinLibrary.fasta")

################################################################################

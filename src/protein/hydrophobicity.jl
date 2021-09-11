################################################################################

using DelimitedFiles
using DataFrames

################################################################################

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

################################################################################

# load hydrophobicity values
hydro = @chain begin
  readdlm("src/protein/hydrophobicity.tsv")
  DataFrame(_, :auto)
  rename!(_, ["AminoAcid", "OneLetterCode", "HydropathyScore"])
end

# cast columns
hydro.AminoAcid = map(χ -> convert(String, χ), hydro.AminoAcid)
hydro.OneLetterCode = map(χ -> AminoAcid(collect(χ)[end]), hydro.OneLetterCode)
hydro.HydropathyScore = map(χ -> convert(Float64, χ), hydro.HydropathyScore)

################################################################################

# load protein database
synAr = syncytinReader("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/CURATEDsyncytinLibrary.fasta")

################################################################################

score = Array{Float64, 1}(undef, 0)
for aa in synAr[1] |> FASTX.sequence
  push!(score, findfirst(χ -> χ == aa, hydro.OneLetterCode) |> π -> hydro[π, :HydropathyScore])
end

################################################################################

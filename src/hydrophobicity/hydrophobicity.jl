################################################################################

# load packages
begin

  using Pkg
  Pkg.activate("/Users/drivas/Factorem/Syncytin/")

  using DelimitedFiles
  using DataFrames
  using RCall
end;

################################################################################

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

################################################################################

"retrive hydropathy value for aminoacid residue"
function calculateHydropathy(record, hydro)
  # contrusct empty score vector
  score = Array{Float64, 1}(undef, 0)
  # collect aminoacid values
  for aa in record |> FASTX.sequence
    push!(score, findfirst(χ -> χ == aa, hydro.OneLetterCode) |> π -> hydro[π, :HydropathyScore])
  end
  return score
end

"slide window with weight to determine local hydrophobicity profile"
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

"plot hydrophobicity profile using R"
function plotHydropathyR(to_plot, title)
  R"
    plot(
      $to_plot,
      type = 'l',
      main = $title,
      sub = 'Kyle-Doolittle hydropathy plot',
      xlab = 'Amino acid sequence',
      ylab = 'Hydropathy',
      xlim = c(0, 750),
      ylim = c(-4, 4)
    )
  "
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

# construct plot
R"pdf('hydropathy.pdf')"

for ι in 1:length(synAr)

  # calculate values
  score = calculateHydropathy(synAr[ι], hydro)
  to_plot = windowSlide(score)

  # plot
  plotHydropathyR(to_plot, string( (synAr[ι] |> FASTX.identifier), " - ", (synAr[ι] |> FASTX.description) ))

end

# close graphic device
R"dev.off()"

################################################################################

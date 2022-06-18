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
  using CSV
  using DataFrames
  using DelimitedFiles

  using FASTX
end;

################################################################################

# load modules
begin
end;

################################################################################

"read dataframe"
function readdf(path, sep = '\t')
  f, h = readdlm(path, sep, header = true)
  DataFrame(f, h |> vec)
end

################################################################################

"write dataframe"
function writedf(path, df::DataFrame, sep = '\t')
  toWrite = [(df |> names |> permutedims); (df |> Array)]
  writedlm(path, toWrite, sep)
end

################################################################################

"read `fasta` file to array"
function fastaReader(ζ::String)

  # declare empty array
  Ω = Vector{FASTX.FASTA.Record}(undef, 0)

  # open reader
  ω = FASTA.Reader(open(ζ, "r"))

  # extract sequences from reader
  for record ∈ ω
    push!(Ω, record)
  end

  # close reader
  close(ω)

  return Ω
end

################################################################################

"write `fasta` file from array"
function fastaWriter(ζ::String, fastaAr::Vector{FASTX.FASTA.Record})

  # loop over array
  open(FASTA.Writer, ζ) do ω
    for ρ ∈ fastaAr
      write(ω, FASTA.Record(FASTX.identifier(ρ), FASTX.description(ρ), FASTX.sequence(ρ)))
    end
  end
end

################################################################################

"collect `fasta` sequences from directory"
function candidateCollect(ix, candidateDir)
  # syncytin candidate sequences
  candidates = readdir(candidateDir)

  # declare empty array
  Ω = Vector{FASTX.FASTA.Record}(undef, 0)

  # count locally
  for ι ∈ ix, ο ∈ ι

    # open reader
    ω = FASTA.Reader(open(string(candidateDir, "/", candidates[ο]), "r"))

    # extract sequences from reader
    for ρ ∈ ω
      push!(Ω, ρ)
    end

    # close reader
    close(ω)
  end

  return Ω
end

################################################################################

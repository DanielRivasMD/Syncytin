####################################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

####################################################################################################

# load packages
begin
  using CSV
  using DataFrames
  using DelimitedFiles

  using FASTX
end;

####################################################################################################

# load modules
begin
end;

####################################################################################################

"read dataframe"
function readdf(path, sep = '\t')
  ƒ, п = readdlm(path, sep, header = true)
  DataFrame(ƒ, п |> vec)
end

"read diamond output"
function readdmnd(path;
  header = [
    "qseqid",
    "sseqid",
    "pident",
    "length",
    "mismatch",
    "gapopen",
    "qstart",
    "qend",
    "sstart",
    "send",
    "evalue",
    "bitscore",
  ])

  try
    @chain begin
      readdlm(path)
      DataFrame(:auto)
      rename!(header)
    end
  catch ε
    @warn "File was not parsed. Returning empty DataFrame" exception = (ε, catch_backtrace())
    DataFrame([ɣ => Any[] for ɣ ∈ header])
  end
end

####################################################################################################

"write dataframe"
function writedf(path, df::Df, sep = '\t') where Df <: DataFrame
  toWrite = [(df |> names |> permutedims); (df |> Array)]
  writedlm(path, toWrite, sep)
end

####################################################################################################

"read `fasta` file to array"
function fastaReader(ζ::S) where S <: String

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

####################################################################################################

"write `fasta` file from array"
function fastaWriter(ζ::S, fastaAr::V{FsR}) where S <: String where V <: Vector where FsR <: FASTX.FASTA.Record

  # loop over array
  open(FASTA.Writer, ζ) do ω
    for ρ ∈ fastaAr
      write(ω, FASTA.Record(FASTX.identifier(ρ), FASTX.description(ρ), FASTX.sequence(ρ)))
    end
  end
end

####################################################################################################

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

####################################################################################################

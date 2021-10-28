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
function fastaReader(fasta::String)

  # declare empty array
  outAr = Array{FASTX.FASTA.Record}(undef, 1)

  let ν = 0
    reader = FASTA.Reader(open(fasta, "r"))

    # extract sequences from reader
    for record ∈ reader
      ν += 1
      if ν == 1
        outAr[1] = record
      else
        push!(outAr, record)
      end
    end
    close(reader)
  end

  return outAr
end

################################################################################

"write `fasta` file from array"
function fastaWriter(fasta::String, fastaAr::Vector{FASTX.FASTA.Record})

  # loop over array
  open(FASTA.Writer, fasta) do ω
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
  candidateOutAr = Array{FASTX.FASTA.Record}(undef, 1)

  # count locally
  let ν = 0
    for ι ∈ ix
      for ο ∈ ι

        # open reader
        reader = FASTA.Reader(open( string( candidateDir, "/", candidates[ο] ), "r"))

        # extract sequences from reader
        for ρ ∈ reader
          ν += 1
          if ν == 1
            candidateOutAr[1] = ρ
          else
            push!(candidateOutAr, ρ)
          end
        end

        # close reader
        close(reader)
      end
    end
  end

  return candidateOutAr
end

################################################################################

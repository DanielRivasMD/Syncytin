################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

# load project enviroment
using Pkg
if Pkg.project().path != string( projDir, "/Project.toml" )
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  import Chain: @chain
  using DelimitedFiles
  using DataFrames
  using FASTX
end;

################################################################################

# variables
begin
  candidateDir = string( projDir, "/data/candidate" )
end

################################################################################

# load modules
begin
  include( string( projDir, "/src/Utilities/ioDataFrame.jl" ) )
end;

################################################################################

# load data
begin
  # load taxonomy
  taxonomyDf = readdf( string( projDir, "/data/phylogeny/taxonomyDf.csv" ), ',')

  # load list
  assemblyList = @chain begin
    readdlm( string( projDir, "/data/wasabi/filter/assemblyList.csv" ), ',' )
    DataFrame(:auto)
    rename!(["assemblySpp", "assemblyID", "annotationID", "readmeLink", "assemblyLink", "annotationLink"])
  end
end;

################################################################################

# select `Carnivora`
carnivoraList = @chain taxonomyDf begin
  filter(:Order => χ -> χ == "Carnivora", _)
  map(χ -> χ .== assemblyList.assemblySpp, _.Species)
  sum
  convert(BitVector, _)
  assemblyList[_, :]
end

# collect indexes on directory
ix = @chain begin
  replace.(carnivoraList.assemblyID, ".fasta.gz" => "")
  map(χ -> match.(Regex(χ), readdir(candidateDir)), _)
  findall.(χ -> !isnothing(χ), _)
end

candidateAr = candidateCollect(ix, candidateDir)

################################################################################

""
function candidateCollect(ix, candidateDir)
  # syncytin candidate sequences
  candidates = readdir(candidateDir)

  # declare empty array
  candidateOutAr = Array{FASTX.FASTA.Record}(undef, 1)

  # count locally
  let ct = 0
    for ι ∈ ix
      for ο ∈ ι

        # open reader
        reader = FASTA.Reader(open( string( candidateDir, "/", candidates[ο] ), "r"))

        # extract sequences from reader
        for ρ ∈ reader
          ct += 1
          if ct == 1
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

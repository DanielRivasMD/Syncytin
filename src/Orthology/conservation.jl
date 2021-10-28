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
  import Chain: @chain

  using CSV
  using DataFrames
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/evolutionaryCalculation.jl" ) )
  include( string( utilDir, "/ioDataFrame.jl" ) )
end;

################################################################################

# load data
begin
  # load taxonomy
  taxonomyDf = @chain begin
    CSV.read( string( phylogenyDir, "/taxonomyDf.csv" ), DataFrame )
    coalesce.("")
  end

  # load list
  assemblyList = @chain begin
    CSV.read( string( wasabiDir, "/filter/assemblyList.csv" ), DataFrame, header = false )
    rename!(["assemblySpp", "assemblyID", "annotationID", "readmeLink", "assemblyLink", "annotationLink"])
  end
end;

################################################################################

# TODO: rewrite as metaprogramming
# select `Carnivora`
carnivoraAr = @chain "Carnivora" begin
  extractTaxon(taxonomyDf, assemblyList)
  selectIxs(candidateDir)
  candidateCollect(candidateDir)
end

################################################################################

filter(:assemblySpp => χ -> _ == χ, carnivoraList)

@chain begin
  map(candidateAr) do χ
    FASTX.description(χ) |> π -> split(π, " ") |> π -> getindex(π, 1)
  end
end

################################################################################

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
  using DataFrames
  using LightXML
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/evolutionaryCalculation.jl" ) )
  include( string( utilDir, "/ioDataFrame.jl" ) )
end;

################################################################################

"construct taxonomy dataframe"
function taxonomist(ζ::String; taxGroups::Vector{String} = ["Kingdom", "Phylum", "Class", "Superorder", "Order", "Suborder", "Family", "genus", "species", "subspecies"])

  # define path
  dir = string( projDir, "/data/taxonomist/" )

  # create data frame
  outDf = DataFrame( :Species => ζ )

  # iterate on taxonomic groups
  for τ ∈ taxGroups
    @debug τ

    # parse XML files
    xfile = string(dir, "/", ζ, "_", τ, ".xml")
    try
      @eval txFile = parse_file( $xfile )
      for γ ∈ child_elements( LightXML.root(txFile) )
        if name(γ) == "name"
          insertcols!(outDf, Symbol(τ) => content(γ))
        end
      end
    catch ε
      @warn "File was not parsed. Rerturning empty DataFrame" exception = (ε, catch_backtrace())
      insertcols!(outDf, Symbol(τ) => "")
    end
  end
  return outDf
end

################################################################################

# declare data frame
taxonomyDf = DataFrame()

# load assembly results
dDir = string( projDir, "/data/diamondOutput/raw" )
spp = readdir(dDir) .|> π -> replace(π, ".tsv" => "")

# iterate on diamond output items
for (ι, υ) ∈ enumerate(spp)
  # collect taxonomy
  taxDf = nothing
  taxDf = taxonomist(υ)
  @debug taxDf

  if !isnothing(taxDf)
    if ι == 1
      global taxonomyDf = taxDf
    else
      taxonomyDf = [taxonomyDf; taxDf]
    end
  end
end

################################################################################

# write csv complete dataframe
writedf( string( projDir, "/data/phylogeny/taxonomyDf.csv" ), taxonomyDf, ',')

################################################################################

# trim subspecies but keep full nomenclature
taxonomyBinominal = @chain taxonomyDf.Species begin
  replace.("_" => " ")
  split.(" ")
  map(χ -> vcat(getindex(χ, [1, 2]), χ), _)
end

# write csv species binominal
writedlm( string( projDir, "/data/phylogeny/taxonomyBinominal.csv" ), taxonomyBinominal, ',' )

################################################################################

# parse superorder
for τ ∈ ["Euarchontoglires", "Afrotheria", "Xenarthra"]
  writedlm( string( phylogenyDir, "/", τ, "Binominal.csv" ), extractTaxon(τ, taxonomyDf, :Superorder), ',' )
end

################################################################################

# parse order
for τ ∈ ["Carnivora", "Rodentia", "Chiroptera", "Perissodactyla", "Artiodactyla", "Pholidota", "Primates"]
  writedlm( string( phylogenyDir, "/", τ, "Binominal.csv" ), extractTaxon(τ, taxonomyDf, :Order), ',' )
end

################################################################################

# parse suborder
for τ ∈ ["Ruminantia"]
  writedlm( string( phylogenyDir, "/", τ, "Binominal.csv" ), extractTaxon(τ, taxonomyDf, :Suborder), ',' )
end

################################################################################

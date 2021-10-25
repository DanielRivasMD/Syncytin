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
  using DataFrames
  using LightXML
end;

################################################################################

# load modules
include( string( projDir, "/src/Utilities/ioDataFrame.jl" ) );

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

# write csv
writedf( string( projDir, "/data/phylogeny/taxonomyDf.csv" ), taxonomyDf, ',')

################################################################################

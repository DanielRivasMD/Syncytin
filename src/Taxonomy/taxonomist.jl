################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  using DataFrames
  using LightXML
end;

################################################################################

# load modules
include( string( projDir, "/src/Utilities/ioDataFrame.jl" ) );

################################################################################

"construct taxonomy dataframe"
function taxonomist(ζ::String; taxGroups::Vector{String} = ["Kingdom", "Phylum", "Class", "Order", "Family", "genus"])

  # define path
  dir = string( projDir, "/data/taxonomist/", ζ )

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

# load assembly results
dDir = string( projDir, "/data/diamondOutput" )
dirs = readdir(dDir)

for ι ∈ eachindex(dirs)
  local sp = dirs[ι]

  taxDf = nothing
  taxDf = taxonomist(sp)
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

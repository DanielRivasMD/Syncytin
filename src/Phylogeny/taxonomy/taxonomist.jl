################################################################################

# load packages
begin

  using Pkg
  Pkg.activate("/Users/drivas/Factorem/Syncytin/")

  using DataFrames
  using LightXML
end;

################################################################################

""
function taxonomist(ζ::String; taxGroups::Vector{String} = ["Kingdom", "Phylum", "Class", "Order", "Family", "genus"])

  # define path
  dir = string( "/Users/drivas/Factorem/Syncytin/data/diamondOutput/", ζ, "/taxonomist" )

  # create data frame
  outDf = DataFrame( :Species => replace(ζ, "_" => " ") )

  # iterate on taxonomic groups
  for τ ∈ taxGroups
    @debug τ

    # parse XML files
    xfile = string(dir, "/", ζ, "_", τ, ".xml")
    try
      @eval txFile = parse_file( $xfile )
      for c ∈ child_elements( LightXML.root(txFile) )
        if name(c) == "name"
          insertcols!(outDf, Symbol(τ) => content(c))
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
dDir = "data/diamondOutput"
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

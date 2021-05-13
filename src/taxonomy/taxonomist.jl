
using DataFrames
using LightXML

function taxonomist(sp::String; taxGroups::Vector{String} = ["Kingdom", "Phylum", "Class", "Order", "Family", "genus"])

  # define path
  dir = string( "/Users/drivas/Factorem/Syncytin/data/diamondOutput/", sp, "/taxonomist" )

  # create data frame
  outDf = DataFrame( :Species => replace(sp, "_" => " ") )

  # iterate on taxonomic groups
  for tx ∈ taxGroups
    @debug tx

    # parse XML files
    txFile = parse_file( string(dir, "/", sp, "_", tx, ".xml") )
    for c ∈ child_elements( LightXML.root(txFile) )
      if name(c) == "name"
        insertcols!(outDf, Symbol(tx) => content(c))
      end
    end
  end

  return outDf
end


# sp = "Acinonyx_jubatus"

# load assembly results
dDir = "data/diamondOutput"
dirs = readdir(dDir)

for ix ∈ eachindex(dirs)
  dr = dirs[ix]

  taxDf = taxonomist(dr)
  @debug taxDf

  if ix == 1
    global outDf = taxDf
  else
    outDf = [outDf; taxDf]
  end

end

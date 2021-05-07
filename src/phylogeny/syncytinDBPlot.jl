
# load packages
using DelimitedFiles
using RCall

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

# run analysis on nucleotide & protein databases
db = [:nucleotide, :protein]
ad = 0

# load syncytin library
for d in [:N, :P]
  global ad += 1

  # read sequences from file
  synAr = Symbol("synAr", d)
  @eval $synAr = syncytinReader( string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )

  # calculate distance & hierarchical clustering
  levAr = Symbol("levAr", d)
  levFile =  string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "levenshteinDistance.tsv")
  @eval if isfile($levFile)
    $levAr = readdlm($levFile)
  else
    $levAr = levenshteinDist($synAr);
    writedlm($levFile, $levAr, '\t')
  end
end




@rput figName
@rput rlevAr
@rput rtagAr
R"source('/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDBPlot.R')"


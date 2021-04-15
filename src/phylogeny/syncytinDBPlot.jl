
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
  @eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )

  # group syncytin sequences
  syngDf = Symbol("syngDf", d)
  @eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )

  # calculate distance & hierarchical clustering
  levAr = Symbol("levAr", d)
  levFile =  string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "levenshteinDistance.tsv")
  @eval if isfile($levFile)
    $levAr = readdlm($levFile)
  else
    $levAr = levenshteinDist(synPAr);
    writedlm($levFile, $levAr, '\t')
  end
end


# nucleotide
syngDf = syngDfN
@rput syngDf

rlevAr = levArN
rtagAr = tagGroup(synArN, syngDfN)

trimIdN = trimmer!(synArN .|> description, rtagAr .!= size(syngDfN, 1) + 1)

rlevAr = trimmer!(rlevAr, rtagAr .!= size(syngDfN, 1) + 1)
rtagAr = trimmer!(rtagAr, rtagAr .!= size(syngDfN, 1) + 1)
figName = "/Users/drivas/Factorem/Syncytin/arch/manuscripts/Figures/hclustNucl.jpg"
# figName = "/Users/drivas/Factorem/Syncytin/arch/manuscripts/Figures/hclustNucl.pdf"

@rput figName
@rput rlevAr
@rput rtagAr

R"source('/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDBPlot.R')"

# protein
syngDf = syngDfP
@rput syngDf

rlevAr = levArP
rtagAr = tagGroup(synArP, syngDfP)

trimIdP = trimmer!(synArP .|> description, rtagAr .!= size(syngDfP, 1) + 1)

rlevAr = trimmer!(rlevAr, rtagAr .!= size(syngDfP, 1) + 1)
rtagAr = trimmer!(rtagAr, rtagAr .!= size(syngDfP, 1) + 1)
figName = "/Users/drivas/Factorem/Syncytin/arch/manuscripts/Figures/hclustProt.jpg"
# figName = "/Users/drivas/Factorem/Syncytin/arch/manuscripts/Figures/hclustProt.pdf"

@rput figName
@rput rlevAr
@rput rtagAr
R"source('/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDBPlot.R')"

# tanglogram
# TODO: finish this up
spIx = findfirst.('[', trimIdP)
for ix in 1:length(spIx)
  @info trimIdP[ix][spIx[ix] + 1:end - 1]
  findall.(trimIdP[ix][spIx[ix] + 1:end - 1], trimIdN)
end

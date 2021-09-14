################################################################################

# load packages
begin

  using Pkg
  Pkg.activate("/Users/drivas/Factorem/Syncytin/")

  using DelimitedFiles
  using RCall
  using FreqTables
end;

################################################################################

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

################################################################################

# calculate distance & hierarchical clustering
levFile =  string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/levenshteinDistance.tsv")
if isfile(levFile)
  levAr = readdlm(levFile)
else
  # load syncytin library
  synAr = syncytinReader( string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/syncytinLibrary.fasta") )
  levAr = levenshteinDist(synAr);
  writedlm(levFile, levAr, '\t')
end

################################################################################

# load syncytin groups
sgDf = CSV.read("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/CURATEDsyncytinGroups.csv", DataFrame, header = ["ID", "Description", "Group"])
synGroups = ((sgDf.Group |> freqtable).dicts .|> keys)[1] |> p -> convert.(String, p)

################################################################################

# subset indexes
ix = convert.(Int64, readdlm("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/CURATEDindexes.csv"))[:, 1]

figName = "/Users/drivas/Factorem/Syncytin/arch/manuscripts/Figures/CURATEDhclustProt.jpg"
rlevAr = levAr[ix, ix]
rtagAr = zeros(Int64, size(sgDf, 1))
for i in eachindex(synGroups)
  rtagAr[synGroups[i] .== sgDf.Group] .= i
end

@rput figName
@rput rlevAr
@rput rtagAr
@rput synGroups
R"source('/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDBPlot.R')"

################################################################################

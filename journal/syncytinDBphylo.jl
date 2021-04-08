
# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");


# load syncytin library
begin

  # read sequences from file
  synPAr = syncytinReader(synDB = "syncytinLibrary.fasta", synDir = "/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/")
  synNAr = syncytinReader(synDB = "syncytinLibrary.fasta", synDir = "/Users/drivas/Factorem/Syncytin/data/syncytinDB/nucleotide/")

  # group syncytin sequences
  syngPDf = syncytinGroupReader(synG = "/Users/drivas/Factorem/Syncytin/data/syncytinDB/syncytinGroupsProt.csv")
  syngNDf = syncytinGroupReader(synG = "/Users/drivas/Factorem/Syncytin/data/syncytinDB/syncytinGroupsNucl.csv")

end;


# plot sequence length
synLenPlot(synPAr, syngPDf)


# calculate distance & hierarchical clustering
levPAr = levenshteinDist(synPAr);


synLevHCPlot(levPAr, syngPDf)


# plot trimmed sequence length
synLenPlot(synPAr, syngPDf, trim = true)


# recalculate without unassigned sequences
synLevHCPlot(levPAr, syngPDf, trim = true, lenAr = buildLen(synPAr, syngPDf))


synLenPlot(synNAr, syngNDf)


levNAr = levenshteinDist(synNAr);


synLevHCPlot(levNAr, syngNDf)


synLenPlot(synNAr, syngNDf, trim = true)


synLevHCPlot(levNAr, syngNDf, trim = true, lenAr = buildLen(synNAr, syngPDf))


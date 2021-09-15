
# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/Utilities/syncytinDB.jl");



# run analysis on nucleotide & protein databases
import DelimitedFiles
db = [:nucleotide, :protein]
ad = 0

for d in [:N, :P]
  global ad += 1

  # load syncytin library

  # read sequences from file
  synAr = Symbol("synAr", d)
  @eval $synAr = syncytinReader( synDB = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta") )

  # group syncytin sequences
  syngDf = Symbol("syngDf", d)
  @eval $syngDf = syncytinGroupReader( synG = string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv") )

  # plot sequence length
  lenPlot = Symbol("lenPlot", d)
  @eval $lenPlot = synLenPlot($synAr, $syngDf)

  # calculate distance & hierarchical clustering
  levAr = Symbol("levAr", d)
  levFile =  string("/Users/drivas/Factorem/Syncytin/data/syncytinDB/", db[ad], "/", "levenshteinDistance.tsv")
  @eval if isfile($levFile)
    $levAr = DelimitedFiles.readdlm($levFile)
  else
    $levAr = levenshteinDist($synAr);
    DelimitedFiles.writedlm($levFile, $levAr, '\t')
  end

  # plot levenshtein distance & hierarchical clustering
  levPlot = Symbol("levPlot", d)
  @eval $levPlot = synLevHCPlot($levAr, $syngDf, $synAr)

  # plot trimmed sequence length
  lenPlotTrim = Symbol("lenPlotTrim", d)
  @eval $lenPlotTrim = synLenPlot($synAr, $syngDf, trim = true)

  # recalculate without unassigned sequences
  levPlotTrim = Symbol("levPlotTrim", d)
  @eval $levPlotTrim = synLevHCPlot($levAr, $syngDf, $synAr, trim = true)

end


lenPlotP


levPlotP


lenPlotTrimP


levPlotTrimP


lenPlotN


levPlotN


lenPlotTrimN


levPlotTrimN

################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

# load project enviroment
using Pkg
if Pkg.project().path != string(projDir, "/Project.toml")
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  using CSV
  using DelimitedFiles
end

################################################################################

# load modules
include(string(projDir, "/src/Utilities/syncytinDB.jl"));

################################################################################

# run analysis on nucleotide & protein databases
db = [:nucleotide, :protein]
ad = 0

for d in [:N, :P]
  global ad += 1

  # load syncytin library

  # read sequences from file
  syncytinAr = Symbol("syncytinAr", d)
  @eval $syncytinAr = fastaReader(syncytinDB = string(projDir, "/data/syncytinDB/", db[ad], "/", "syncytinLibrary.fasta"))

  # group syncytin sequences
  syngDf = Symbol("syngDf", d)
  @eval $syngDf = CSV.read(synG = string(projDir, "/data/syncytinDB/", db[ad], "/", "syncytinGroups.csv"), DataFrame, header = false)

  # plot sequence length
  lenPlot = Symbol("lenPlot", d)
  @eval $lenPlot = syncytinLenPlot($syncytinAr, $syngDf)

  # calculate distance & hierarchical clustering
  levAr = Symbol("levAr", d)
  levFile =  string(projDir, "/data/syncytinDB/", db[ad], "/", "levenshteinDistance.tsv")
  @eval if isfile($levFile)
    $levAr = DelimitedFiles.readdlm($levFile)
  else
    $levAr = levenshteinDist($syncytinAr);
    DelimitedFiles.writedlm($levFile, $levAr, '\t')
  end

  # plot levenshtein distance & hierarchical clustering
  levPlot = Symbol("levPlot", d)
  @eval $levPlot = syncytinLevHPlot($levAr, $syngDf, $syncytinAr)

  # plot trimmed sequence length
  lenPlotTrim = Symbol("lenPlotTrim", d)
  @eval $lenPlotTrim = syncytinLenPlot($syncytinAr, $syngDf, trim = true)

  # recalculate without unassigned sequences
  levPlotTrim = Symbol("levPlotTrim", d)
  @eval $levPlotTrim = syncytinLevHPlot($levAr, $syngDf, $syncytinAr, trim = true)

end

################################################################################

lenPlotP


levPlotP


lenPlotTrimP


levPlotTrimP


lenPlotN


levPlotN


lenPlotTrimN


levPlotTrimN

################################################################################

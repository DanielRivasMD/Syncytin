################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  using DelimitedFiles
  using RCall
  using FreqTables
end;

################################################################################

# load modules
include( string( projDir, "/src/Utilities/syncytinDB.jl" ) );

################################################################################

# calculate distance & hierarchical clustering
levFile =  string( collectionDB, "/protein/levenshteinDistance.tsv" )
if isfile(levFile)
  levAr = readdlm(levFile)
else
  # load syncytin library
  synAr = syncytinReader( string( collectionDB, "/protein/syncytinLibrary.fasta" ) )
  levAr = levenshteinDist(synAr);
  writedlm(levFile, levAr, '\t')
end

################################################################################

# load syncytin groups
sgDf = CSV.read( string( collectionDB, "/protein/CURATEDsyncytinGroups.csv" ), DataFrame, header = ["ID", "Description", "Group"] )
synGroups = ((sgDf.Group |> freqtable).dicts .|> keys)[1] |> π -> convert.(String, π)

################################################################################

# subset indexes
ι = convert.(Int64, readdlm( string( collectionDB, "/protein/CURATEDindexes.csv" ) ))[:, 1]

figName = string( projDir, "/arch/manuscripts/Figures/CURATEDhclustProt.jpg" )
rlevAr = levAr[ι, ι]
rtagAr = zeros(Int64, size(sgDf, 1))
for ι in eachindex(synGroups)
  rtagAr[synGroups[ι] .== sgDf.Group] .= ι
end

@rput figName
@rput rlevAr
@rput rtagAr
@rput synGroups
R"source( paste0( $projDir, '/src/Clustering/syncytinDBPlot.R' ) )"

################################################################################

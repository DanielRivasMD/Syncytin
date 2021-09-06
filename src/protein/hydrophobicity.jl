################################################################################

using DelimitedFiles
using DataFrames

################################################################################

# load modules & functions
include("/Users/drivas/Factorem/Syncytin/src/phylogeny/syncytinDB.jl");

################################################################################

# load hydrophobicity values
hydro = @chain begin
  readdlm("src/protein/hydrophobicity.tsv")
  DataFrame(_, :auto)
  rename!(_, ["AminoAcid", "OneLetterCode", "HydropathyScore"])
end

################################################################################

# load protein database
synAr = syncytinReader("/Users/drivas/Factorem/Syncytin/data/syncytinDB/protein/CURATEDsyncytinLibrary.fasta")

################################################################################

################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string(projDir, "/Project.toml")
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  using Chain: @chain

  using CSV
  using DataFrames
  using RCall
end;

################################################################################

# load modules
begin
  include(string(utilDir, "/evolutionaryCalculation.jl"))
  include(string(utilDir, "/fastaOperations.jl"))
  include(string(utilDir, "/ioDataFrame.jl"))
end;

################################################################################

# load data
begin
  # load taxonomy
  taxonomyDf = @chain begin
    CSV.read(string(phylogenyDir, "/taxonomyDf.csv"), DataFrame)
    coalesce.("")
  end

  # load list
  assemblyDf = @chain begin
    CSV.read(DNAzooList, DataFrame, header = false)
    rename!(["assemblySpp", "assemblyID", "annotationID", "readmeLink", "assemblyLink", "annotationLink"])
  end
end;

################################################################################

# collect carnivora tree
R"
require(treeio)
carnivoraTree <- read.tree(paste0($phylogenyDir, '/CarnivoraBinominal.nwk'))
carnivoraSort <- carnivoraTree$tip.label
"

@rget carnivoraSort

################################################################################

# TODO: rewrite as metaprogramming

# select `Carnivora`
carnivoraArN = @chain carnivoraSort begin
  extractTaxon(taxonomyDf, assemblyDf)
  selectIxs(candidateDir)
  candidateCollect(candidateDir)
end

################################################################################

# translate fasta array
carnivoraArP = translateRecord(carnivoraArN)

################################################################################

# write fasta records
fastaWriter(string(alignmentDir, "/nucleotide/carnivora.fna"), carnivoraArN)
fastaWriter(string(alignmentDir, "/protein/carnivora.faa"), carnivoraArP)

################################################################################

################################################################################

# collect carnivora tree
R"
require(treeio)
ursidaeTree <- read.tree(paste0($phylogenyDir, '/UrsidaeBinominal.nwk'))
ursidaeSort <- ursidaeTree$tip.label
"

@rget ursidaeSort

################################################################################

# TODO: rewrite as metaprogramming
# select `Ursidae`
ursidaeArN = @chain ursidaeSort begin
  extractTaxon(taxonomyDf, assemblyDf)
  selectIxs(candidateDir)
  candidateCollect(candidateDir)
end

################################################################################

# translate fasta array
ursidaeArP = translateRecord(ursidaeArN)

################################################################################

# write fasta records
fastaWriter(string(alignmentDir, "/nucleotide/ursidae.fna"), ursidaeArN)
fastaWriter(string(alignmentDir, "/protein/ursidae.faa"), ursidaeArP)

################################################################################

# ################################################################################

# TODO: pangolins do not present hits
# TODO: phataginus tricuspis is renamed to manis tricuspis
# # collect carnivora tree
# R"
# require(treeio)
# pholidotaTree <- read.tree(paste0($phylogenyDir, '/PholidotaBinominal.nwk'))
# pholidotaSort <- pholidotaTree$tip.label
# "

# @rget pholidotaSort

# ################################################################################

# # TODO: rewrite as metaprogramming
# # select `Carnivora`
# pholidotaN = @chain pholidotaSort begin
#   extractTaxon(taxonomyDf, assemblyDf)
#   selectIxs(candidateDir)
#   candidateCollect(candidateDir)
# end

# ################################################################################

# # translate fasta array
# pholidotaP = translateRecord(pholidotaN)

# ################################################################################

# # write fasta records
# fastaWriter(string(alignmentDir, "/nucleotide/pholidota.fna"), pholidotaN)
# fastaWriter(string(alignmentDir, "/protein/pholidota.faa"), pholidotaP)

# ################################################################################

# calculate levenshtein distance
carnivoraMt = levenshteinDist(carnivoraArP)

################################################################################

# # empty loci vector
# carnivoraVc = Vector{Tuple{String, LongDNASeq}}(undef, 0)
#
# # iterate on carnivora clade
# for υ ∈ carnivoraSort
#   records = filter(χ -> FASTX.description(χ) |> π -> split(π, " ") |> π -> getindex(π, 1) == υ, carnivoraAr)
#   if length(records) > 0 ν += 1 end
#   for ρ ∈ records
#     push!(carnivoraVc, (FASTX.description(ρ), FASTX.sequence(ρ)))
#   end
# end

################################################################################

# # empty matrix
# carnivoraMt = Matrix{Float64}(undef, length(carnivoraAr), length(carnivoraAr))
#
#
# for (ι, υ) ∈ enumerate(carnivoraVc)
#   Υ = length(υ[2]) % 3
#   seq1 = BioSequences.translate(υ[2][1:end - Υ])
#   for (ο, ψ) ∈ enumerate(carnivoraVc)
#     Ψ = length(ψ[2]) % 3
#     seq2 = BioSequences.translate(ψ[2][1:end - Ψ])
#     carnivoraMt[ι, ο] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
#   end
# end

# @info filter(χ -> FASTX.description(χ) == υ, carnivoraAr) |> π -> FASTX.sequence(π[1]) |> π -> BioSequences.translate(π)

################################################################################

# filter(:assemblySpp => χ -> _ == χ, carnivoraList)
#
# @chain begin
#   map(carnivoraAr) do μ
#     FASTX.description(μ) |> π -> split(π, " ") |> π -> getindex(π, 1)
#   end
#
#   map(_) do μ
#      filter(χ -> FASTX.description(χ) |> π -> split(π, " ") |> π -> getindex(π, 1) == μ, carnivoraAr)
#   end
# end

################################################################################



# ["Cryptoprocta_ferox", "Suricata_suricatta", "Crocuta_crocuta", "Panthera_tigris", "Panthera_pardus", "Panthera_onca"
# "Panthera_uncia", "Neofelis_nebulosa", "Felis_nigripes", "Prionailurus_viverrinus" "Puma_concolor", "Puma_yagouaroundi"
# "Acinonyx_jubatus", "Chrysocyon_brachyurus", "Lycaon_pictus", "Canis_lupus", "Otocyon_megalotis", "Vulpes_vulpes"
# "Potos_flavus", "Bassariscus_astutus", "Bassariscus_sumichrasti" "Nasua_narica", "Pteronura_brasiliensis"  "Aonyx_cinerea"
# "Lutra_lutra", "Enhydra_lutris", "Lontra_canadensis", "Mustela_putorius", "Martes_martes", "Martes_foina"
# "Martes_flavigula", "Ailurus_fulgens", "Arctocephalus_townsendi" "Odobenus_rosmarus", "Mirounga_angustirostris" "Monachus_schauinslandi"
# "Phoca_largha", "Phoca_vitulina", "Halichoerus_grypus", "Erignathus_barbatus", "Ursus_americanus", "Helarctos_malayanus"
# "Ursus_arctos", "Ursus_maritimus", "Tremarctos_ornatus"]

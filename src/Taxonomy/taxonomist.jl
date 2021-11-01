################################################################################

# declarations
begin
  include( "/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl" )
end;

################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string( projDir, "/Project.toml" )
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
  import Chain: @chain

  using DataFrames
  using LightXML
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/evolutionaryCalculation.jl" ) )
  include( string( utilDir, "/ioDataFrame.jl" ) )
end;

################################################################################

# declare data frame
taxonomyDf = DataFrame()

# load assembly results
dDir = string( diamondDir, "/raw" )
spp = readdir(dDir) .|> π -> replace(π, ".tsv" => "")

# iterate on diamond output items
for (ι, υ) ∈ enumerate(spp)
  # collect taxonomy
  taxDf = nothing
  taxDf = taxonomist(υ)
  @debug taxDf

  # append rows
  for ρ ∈ eachrow(taxDf)
    push!(taxonomyDf, ρ)
  end
end

################################################################################
# patch binominal nomenclature
################################################################################

# homotypic synonim
taxonomyDf[(taxonomyDf.Species .== "Aonyx_cinereus"), :species] .= "Amblonyx cinereus"

# deprecated name
taxonomyDf[(taxonomyDf.Species .== "Equues_quagga"), :species] .= "Equus burchellii"

# dingo ecotypes
taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_dingo_alpine_ecotype"), Not(:Species)] .= taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_dingo"), Not(:Species)]
taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_dingo_desert_ecotype"), Not(:Species)] .= taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_dingo"), Not(:Species)]

# dog breeds
taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_familiaris_Basenji"), Not(:Species)] .= taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_familiaris"), Not(:Species)]
taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_familiaris_German_Shepherd"), Not(:Species)] .= taxonomyDf[(taxonomyDf.Species .== "Canis_lupus_familiaris"), Not(:Species)]

# golden hamster
taxDf = taxonomist("Mesocricetus_auratus")
taxonomyDf[(taxonomyDf.Species .== "Mesocricetus_auratus__MesAur1.0"), Not(:Species)] .= taxDf[(taxDf.Species .== "Mesocricetus_auratus"), Not(:Species)]
taxonomyDf[(taxonomyDf.Species .== "Mesocricetus_auratus__golden_hamster_wtdbg2.shortReadsPolished"), Not(:Species)] .= taxDf[(taxDf.Species .== "Mesocricetus_auratus"), Not(:Species)]

# chinchilla hybrid, wild dog, donkey, rock hyrax
patchAr = ["Chinchilla_lanigera", "Equus_asinus", "Lycaon_pictus", "Procavia_capensis"]
defectiveAr = ["Chinchilla_x", "Equus_asinus__ASM303372v1", "Lycaon_pictus__sis2-181106", "Procavia_capensis__Pcap_2.0"]

for ι ∈ eachindex(patchAr)
  taxDf = taxonomist(patchAr[ι])
  taxonomyDf[(taxonomyDf.Species .== defectiveAr[ι]), Not(:Species)] .= taxDf[(taxDf.Species .== patchAr[ι]), Not(:Species)]
end

################################################################################

# write csv complete dataframe
writedf( string( phylogenyDir, "/taxonomyDf.csv" ), taxonomyDf, ',')

################################################################################

# trim subspecies but keep full nomenclature
writedf( string( phylogenyDir, "/taxonomyBinominal.csv" ), taxonomyDf[:, [:species, :Species]], ',' )

################################################################################

# parse superorder
for τ ∈ ["Euarchontoglires", "Afrotheria", "Xenarthra"]
  writedf( string( phylogenyDir, "/", τ, "Binominal.csv" ), extractTaxon(τ, taxonomyDf, :Superorder), ',' )
end

################################################################################

# parse order
for τ ∈ ["Carnivora", "Rodentia", "Chiroptera", "Perissodactyla", "Artiodactyla", "Pholidota", "Primates"]
  writedf( string( phylogenyDir, "/", τ, "Binominal.csv" ), extractTaxon(τ, taxonomyDf, :Order), ',' )
end

################################################################################

# parse suborder
for τ ∈ ["Ruminantia"]
  writedf( string( phylogenyDir, "/", τ, "Binominal.csv" ), extractTaxon(τ, taxonomyDf, :Suborder), ',' )
end

################################################################################

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
  using DelimitedFiles
end;

################################################################################

# load modules
begin
  include(string(utilDir, "/arrayOperations.jl"))
  include(string(utilDir, "/ioDataFrame.jl"))
  include(string(utilDir, "/fastaOperations.jl"))
end;

################################################################################

# manually annoatated groups
groupAnnoation = String[
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Carnivora [Car1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Ruminantia [rum1]",
"Opossum [Opo1]",
"Opossum [Opo1]",
"Opossum [Opo1]",
"Opossum [Opo1]",
"Opossum [Opo1]",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Marsupial2",
"Opossum [Opo1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Tenrec [Ten1]",
"Mabuya",
"Mabuya",
"Mabuya",
"Mabuya",
"HomoSapiens [syn1]",
"HomoSapiens [syn2]",
"Rodentia [synA]",
"Rodentia [synB]",
"Oryctolagus [Ory1]",
"Carnivora [Car1]",
"Rodentia [synA]",
"Rodentia [synA]",
"Rodentia [synA]",
"Rodentia [synA]",
"Rodentia [synB]",
"Rodentia [synB]",
"Rodentia [synB]",
"Rodentia [synB]",
"Rodentia [synB]",
"Hyeanidae",
"Hyeanidae",
"Hyeanidae",
"Hyeanidae",
"Hyeanidae",
"Hyeanidae",
"Hyeanidae",
"Xenartra [das1]",
"HomoSapiens [syn1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Marsupial1 [Mar1]",
"Rodentia [synA]",
"Rodentia [synA]",
"Rodentia [synA]",
"Rodentia [synA]",
"Rodentia [synB]",
"Rodentia [synB]",
"Rodentia [synB]",
"Rodentia [Cav1]",
"Rodentia [Cav1]",
"Rodentia [Cav1]",
"Rodentia [Cav1]",
"Rodentia [Cav1]",
]

################################################################################

# load protein database
syncytinAr = fastaReader(string(syncytinDBDir, "/protein/syncytinLibrary.fasta"))

################################################################################

# declare filter criteria & specific sequences to exclude
selectIxs = @pipe syncytinAr |> findall(x ->
  FASTA.seqlen(x) >= 400 && (
    contains(FASTX.description(x), "syncytin") ||
    contains(FASTX.description(x), "envelope") ||
    isequal(FASTX.description(x), "sodium-dependent neutral amino acid transporter type 2 [Dasypus novemcinctus]")
  ) && (
    !isequal(FASTX.description(x), "PREDICTED: similar to envelope glycoprotein syncytin-B [Rattus norvegicus]") &&
    !isequal(FASTX.description(x), "envelope glycoprotein [RD114 retrovirus]") &&
    !isequal(FASTX.description(x), "envelope protein [Trichosurus vulpecula]") &&
    !isequal(FASTX.description(x), "envelope glycoprotein [Squirrel monkey retrovirus]") &&
    !isequal(FASTX.description(x), "envelope glycoprotein [Squirrel monkey retrovirus-H]") &&
    !isequal(FASTX.description(x), "envelope polyprotein [Simian retrovirus 1]") &&
    !isequal(FASTX.description(x), "envelope protein [Simian retrovirus 4]") &&
    !isequal(FASTX.description(x), "envelope polyprotein [Human immunodeficiency virus 1]")
  ), _)

selectRecords = getindex(syncytinAr, selectIxs)

################################################################################

# recover sequence information
sequenceDs = FASTX.description.(selectRecords)
sequenceId = FASTX.identifier.(selectRecords)

# purge duplicated sequences
selectIx = selectRecords .|> FASTX.sequence |> uniqueix
selectRecords = selectRecords |> purgeSequences

################################################################################

# write curated indexes
writedlm(string(syncytinDBDir, "/protein/CURATEDindexes.csv"), selectIxs[selectIx])

################################################################################

# bind array to write
syncytinGroups = [sequenceId sequenceDs groupAnnoation][selectIx, :]

# write curated group annoation
writedlm(string(syncytinDBDir, "/protein/CURATEDsyncytinGroups.csv"), syncytinGroups, ',')

################################################################################

# write curated fasta library
fastaWriter(string(syncytinDBDir, "/protein/CURATEDsyncytinLibrary.fasta"), selectRecords)

################################################################################

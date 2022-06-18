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
  using CSV
  using DataFrames
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

# carnivora taxon
carnivoraDf = extractTaxon("Carnivora", taxonomyDf, assemblyDf)

################################################################################

# declare data frame
syntenyCladeDf = DataFrame(spp = String[], scaffold = String[], start = Int64[], tmp = Int64[], orientation = String[], gene = String[])
rename!(syntenyCladeDf, :tmp => :end) # patch not available column name

# declare columns to select
parseCols = [:spp, :scaffold, :start, :end, :orientation, :gene]

################################################################################

# iterate on annotations
for υ ∈ eachrow(carnivoraDf)

  # collect loci
  annotationAr = @chain begin
    readdir(syntenyDir)
    filter(χ -> occursin(replace(υ.annotationID, ".fasta_v2.functional.gff3.gz" => ""), χ), _)
    filter(χ -> occursin("gene.csv", χ), _)
  end

  # iterate over loci
  for α ∈ annotationAr
    csvDf = @chain begin
      CSV.read(string(syntenyDir, "/", α), DataFrame)
      coalesce.("")
      rename!(:seqid => :scaffold, :strand => :orientation, :att_note => :gene)
    end
    csvDf.spp = repeat([υ.assemblySpp], size(csvDf, 1))

    # syncytin
    @chain csvDf begin
      filter(:distance => χ -> χ == 0, _)
      _[1, parseCols]
      push!(syntenyCladeDf, _)
    end

    # upstream
    @chain csvDf begin
      filter(:distance => χ -> χ < 0, _)
      if size(_, 1) > 0 _[argmax(_.distance), parseCols] end
      if !isnothing(_) push!(syntenyCladeDf, _)
      end
    end

    # downstream
    @chain csvDf begin
      filter(:distance => χ -> χ > 0, _)
      if size(_, 1) > 0 _[argmin(_.distance), parseCols] end
      if !isnothing(_) push!(syntenyCladeDf, _) end
    end
  end
end

################################################################################

# write csv
writedf(string(phylogenyDir, "/syntenyCladeDf.csv"), syntenyCladeDf, ',')

################################################################################

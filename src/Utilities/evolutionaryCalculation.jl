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
  using BioSequences
  using Clustering
  using FASTX
end;

################################################################################

# load modules
begin
end;

################################################################################

"construct taxonomy dataframe"
function taxonomist(ζ::String; taxGroups::Vector{String} = ["Kingdom", "Phylum", "Class", "Superorder", "Order", "Suborder", "Family", "genus", "species", "subspecies"])

  # create data frame
  outDf = DataFrame( :Species => ζ )

  # iterate on taxonomic groups
  for τ ∈ taxGroups
    @debug τ

    # parse XML files
    xfile = string( taxonomistDir, "/", ζ, "_", τ, ".xml" )
    try
      @eval txFile = parse_file( $xfile )
      for γ ∈ child_elements( LightXML.root(txFile) )
        if name(γ) == "name"
          insertcols!(outDf, Symbol(τ) => content(γ))
        end
      end
    catch ε
      @warn "File was not parsed. Rerturning empty DataFrame" exception = (ε, catch_backtrace())
      insertcols!(outDf, Symbol(τ) => "")
    end
  end
  return outDf
end

################################################################################

"calculate levenshtein distances"
function levenshteinDist(fastaAr::Vector{FASTX.FASTA.Record})

  # construct array
  fastaLen = length(fastaAr)
  outLevAr = zeros(Float64, fastaLen, fastaLen)

  for ι ∈ eachindex(fastaLen)
    seq1 = FASTX.sequence(fastaAr[ι])
    for ο ∈ eachindex(fastaLen)
      # omit diagonal
      if ( ι == ο ) continue end

      # use memoization
      if outLevAr[ο, ι] != 0
        outLevAr[ι, ο] = outLevAr[ο, ι]
      else
        seq2 = FASTX.sequence(fastaAr[ο])
        outLevAr[ι, ο] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
     end

    end
  end

  return outLevAr
end

"build hierarchical clustering"
function levHClust(levAr::Matrix{Float64})
  return Clustering.hclust(levAr, linkage = :average, branchorder = :optimal)
end

################################################################################

"return best position (highest identity percentage) on alignment"
function bestPosition(df::DataFrame)
  #  TODO: alternatively, find minimum e-value
  #  TODO: round start & end positions
  return combine(groupby(df, [:QueryAccession, :QueryStart, :QueryEnd])) do χ
    χ[argmax(χ.SequenceIdentity), :]
  end
end

################################################################################

"extract subset of assemblies for a taxon & parser binominal nomenclature"
function extractTaxon(taxon::String, taxDf::DataFrame, level::Symbol)
  @chain taxDf begin
    filter(level => χ -> χ == taxon, _)
    select([:species, :Species])
  end
end

################################################################################

"extract subset of assemblies for a taxon & match against list"
function extractTaxon(taxon::String, taxDf::DataFrame, list::String; level::Symbol = :Order)
  @chain taxDf begin
    filter(level => χ -> χ == taxon, _)
    map(χ -> χ .== list.assemblySpp, _.Species)
    sum
    convert(BitVector, _)
    list[_, :]
  end
end

################################################################################

"select file indexes from directory"
function selectIxs(list, dir)
  @chain begin
    replace.(list.assemblyID, ".fasta.gz" => "")
    map(χ -> match.(Regex(χ), readdir(dir)), _)
    findall.(χ -> !isnothing(χ), _)
  end
end

################################################################################

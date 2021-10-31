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
  using DataFrames

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

""

################################################################################

"calculate levenshtein distances"
function levenshteinDist(fastaAr::Vector{FASTX.FASTA.Record})

  # construct array
  fastaLen = length(fastaAr)
  Ω = zeros(Float64, fastaLen, fastaLen)

  for ι ∈ eachindex(fastaLen)
    seq1 = FASTX.sequence(fastaAr[ι])
    for ο ∈ eachindex(fastaLen)
      # omit diagonal
      if ( ι == ο ) continue end

      # use memoization
      if Ω[ο, ι] != 0
        Ω[ι, ο] = Ω[ο, ι]
      else
        seq2 = FASTX.sequence(fastaAr[ο])
        Ω[ι, ο] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
     end

    end
  end

  return Ω
end

"build hierarchical clustering"
function levHClust(levAr::Matrix{Float64})
  return Clustering.hclust(levAr, linkage = :average, branchorder = :optimal)
end

################################################################################

"construct compossed matrix"
function fuseMatrix(α, β)
  # check arrays
  if size(α, 1) != size(α, 2) @error "Matrix is not square" end
  if size(α) != size(β) @error "Input arrays are not the same size and cannot be combined" end

  Ω = Array{Int64, 2}(undef, size(α))
  for ι ∈ 1:size(α, 1)
    for ο ∈ 1:size(α, 2)
      # omit diagonal
      if ( ι == ο ) Ω[ι, ο] = 0 end

      # upper triangle
      if ( ι < ο ) Ω[ι, ο] = α[ι, ο] end

      # lower triangle
      if ( ι > ο ) Ω[ι, ο] = β[ι, ο] end
    end
  end
  return Ω
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
function extractTaxon(taxon::String, taxDf::DataFrame, list::DataFrame, level::Symbol = :Order)
  @chain taxDf begin
    filter(level => χ -> χ == taxon, _)
    map(χ -> findall(χ .== list.assemblySpp), _.Species)
    sum.(_)
    list[_, :]
  end
end

################################################################################

"extract subset of assemblies given sort & match against list"
function extractTaxon(sort::Vector{String}, taxDf::DataFrame, list::DataFrame)
  @chain taxDf begin
    map(χ -> findall(χ .== _.Species), sort)
    sum.(_)
    filter(χ -> χ > 0, _)
    taxDf[_, :]
    map(χ -> findall(χ .== list.assemblySpp), _.Species)
    sum.(_)
    filter(χ -> χ > 0, _)
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

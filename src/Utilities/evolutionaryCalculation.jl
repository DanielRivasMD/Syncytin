####################################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

####################################################################################################

# load packages
begin
  using DataFrames

  using BioSequences
  using Clustering
  using FASTX
end;

####################################################################################################

# load modules
begin
end;

####################################################################################################

"construct taxonomy dataframe"
function taxonomist(ϛ::S;
  taxGroups::V{S} = [
    "Class",
    "Infraclass",
    "Superorder",
    "Order",
    "Suborder",
    "Infraorder",
    "Family",
    "genus",
    "species",
    "subspecies",
  ]) where S <: String where V <: Vector

  # create data frame
  Ω = DataFrame(:Species => ϛ)

  # iterate on taxonomic groups
  for τ ∈ taxGroups
    @debug τ

    # parse XML files
    xfile = string(taxonomistDir, "/", ϛ, "_", τ, ".xml")
    try
      @eval txFile = parse_file($xfile)
      for γ ∈ child_elements(LightXML.root(txFile))
        if name(γ) == "name"
          insertcols!(Ω, Symbol(τ) => content(γ))
        end
      end
    catch ε
      @warn "File was not parsed. Returning empty DataFrame" exception = (ε, catch_backtrace())
      insertcols!(Ω, Symbol(τ) => "")
    end
  end
  return Ω
end

####################################################################################################

"calculate levenshtein distances"
function levenshteinDist(ɒ::V{FsR}) where V <: Vector FsR <: FASTX.FASTA.Record

  # construct array
  fastaLen = length(ɒ)
  Ω = zeros(Float64, fastaLen, fastaLen)

  for ι ∈ 1:fastaLen
    seq1 = FASTX.sequence(ɒ[ι])
    for ο ∈ 1:fastaLen
      # omit diagonal
      if (ι == ο) continue end

      # use memoization
      if Ω[ο, ι] != 0
        Ω[ι, ο] = Ω[ο, ι]
      else
        seq2 = FASTX.sequence(ɒ[ο])
        Ω[ι, ο] = BioSequences.sequencelevenshtein_distance(seq1, seq2) / maximum([length(seq1), length(seq2)]) * 100
     end

    end
  end

  return Ω
end

"build hierarchical clustering"
function levHClust(ɒ::M{F}) where M <: Matrix where F <: Float64
  return Clustering.hclust(ɒ, linkage = :average, branchorder = :optimal)
end

####################################################################################################

"construct compossed matrix"
function fuseMatrix(ɒ1, ɒ2)
  # check arrays
  if size(ɒ1, 1) != size(ɒ1, 2) @error "Matrix is not square" end
  if size(ɒ1) != size(ɒ2) @error "Input arrays are not the same size and cannot be combined" end

  Ω = Matrix{Int64}(undef, size(ɒ1))
  for ι ∈ 1:size(ɒ1, 1), ο ∈ 1:size(ɒ1, 2)
    # omit diagonal
    if (ι == ο) Ω[ι, ο] = 0 end

    # upper triangle
    if (ι < ο) Ω[ι, ο] = ɒ1[ι, ο] end

    # lower triangle
    if (ι > ο) Ω[ι, ο] = ɒ2[ι, ο] end
  end
  return Ω
end

####################################################################################################

"return best position (highest identity percentage) on alignment"
function bestPosition(ϙ::Df) where Df <: DataFrame
  return combine(groupby(ϙ, [:QueryAccession])) do δ
    purgeClose(DataFrame(δ))
  end
end

####################################################################################################

"purge close positions"
function purgeClose(ϙ::Df) where Df <: DataFrame
  # declare output
  Ω = DataFrame(QueryAccession = String[], TargetAccession = String[], SequenceIdentity = Float64[], Length = Int64[], Mismatches = Int64[], GapOpenings = Int64[], QueryStart = Int64[], QueryEnd = Int64[], TargetStart = Int64[], TargetEnd = Int64[], EValue = Float64[], BitScore = Float64[], Group = String[], Species = String[])

  # declare symbols
  edges = [:Start, :End]

  # round coordinates
  for з ∈ edges
    ϙ[:, Symbol(:Round, з)] = map(ϙ[:, Symbol(:Query, з)]) do μ slide(μ, 100, [0, 50]) end
  end

  # exhaust data
  while size(ϙ, 1) != 0

    for з ∈ edges
      ϙ[:, Symbol(:Eq, з)] .= 1

      ϙ[Not(argmax(ϙ.SequenceIdentity)), Symbol(:Eq, з)] .= sum.(map(ϙ[Not(argmax(ϙ.SequenceIdentity)), Symbol(:Round, з)]) do μ
        μ .== ϙ[(argmax(ϙ.SequenceIdentity)), Symbol(:Round, з)]
      end)

      ϙ[ϙ[:, Symbol(:Eq, з)] .> 0, Symbol(:Eq, з)] .= 1
    end

    ϙ[:, :Eq] .= ϙ[:, Symbol(:Eq, edges[1])] .+ ϙ[:, Symbol(:Eq, edges[2])]

    push!(Ω, ϙ[ϙ[:, :Eq] .== 2, :] |> π -> π[argmax(π.SequenceIdentity), Cols(Not(r"Round|Eq"))])

    ϙ = ϙ[ϙ[:, :Eq] .< 2, :]
  end

  return Ω
end

####################################################################################################

"extract subset of assemblies for a taxon & match against list"
function extractTaxon(τ::S, ϙ::Df, ł::Df; level::Y = :Order, speciesList::Y = :assemblySpp) S <: String where Df <: DataFrame Y <: Symbol
  ξ = Vector{Int64}(undef, 0)
  @chain ϙ begin
    filter(level => χ -> χ == τ, _)
    map(χ -> findall(χ .== ł[:, speciesList]), _.Species)
    map(_) do μ append!(ξ, μ) end
  end
  return ł[ξ, :]
end

####################################################################################################

"extract subset of assemblies given sort & match against list"
function extractTaxon(ζ::V{S}, ϙ::Df, ł::Df; speciesList::Y = :assemblySpp) where V <: Vector where S <: String where Df <: DataFrame Y <: Symbol
  @chain ϙ begin
    map(χ -> findall(χ .== _.Species), ζ)
    sum.(_)
    filter(χ -> χ > 0, _)
    ϙ[_, :]
    map(χ -> findall(χ .== ł[:, speciesList]), _.Species)
    sum.(_)
    filter(χ -> χ > 0, _)
    ł[_, :]
  end
end

####################################################################################################

"select file indexes from directory"
function selectIxs(ł, dir)
  @chain begin
    replace.(ł.assemblyID, ".fasta.gz" => "")
    map(χ -> match.(Regex(χ), readdir(dir)), _)
    findall.(χ -> !isnothing(χ), _)
  end
end

####################################################################################################

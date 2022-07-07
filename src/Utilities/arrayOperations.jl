################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

################################################################################

# load packages
begin
end;

################################################################################

# load modules
begin
end;

################################################################################

"select non unique elements"
function nunique(α::AbstractArray{T}) where T
  xs = sort(α)
  duplicatedvector = T[]
  for ι ∈ 2:length(xs)
    if (isequal(xs[ι], xs[ι - 1]) && (length(duplicatedvector) == 0 || !isequal(duplicatedvector[end], xs[ι])))
      push!(duplicatedvector, xs[ι])
    end
  end
  duplicatedvector
end

"select unique element indexes"
function uniqueix(α::AbstractArray{T}) where T
  uniqueset = Set{T}()
  ex = eachindex(α)
  ixs = Vector{eltype(ex)}()
  for ι ∈ ex
    xi = α[ι]
    if !(xi ∈ uniqueset)
      push!(ixs, ι)
      push!(uniqueset, xi)
    end
  end
  ixs
end

################################################################################

"trim matrix based on vector"
function trimmer!(douAr::Matrix, trimVc::BitVector)
  return douAr[trimVc, trimVc]
end

"trim array based on vector"
function trimmer!(unAr::Vector, trimVc::BitVector)
  return unAr[trimVc]
end

################################################################################

"window slider"
function slide(η, θ, ξ)
  return (η + ξ) |> π -> (π / θ) |> floor |> π -> (π * θ)
end

"window slider with overlap"
function slide(η, θ, ξ::Vector)
  return (slide(η, θ, ξ[1]), slide(η, θ, ξ[2]))
end

################################################################################

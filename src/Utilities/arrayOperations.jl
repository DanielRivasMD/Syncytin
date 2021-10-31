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
####################################################################################################

# declarations
begin
  include("/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl")
end;

####################################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string(projDir, "/Project.toml")
  Pkg.activate(projDir)
end

####################################################################################################

# load packages
begin
  using Chain: @chain

  # plots
  using UnicodePlots

  using DataFrames
end;

####################################################################################################

# load modules
begin
  include(string(utilDir, "/ioDataFrame.jl"))
end;

####################################################################################################

# read raw output
ł = @chain begin
  readdir(string(diamondDir, "/raw"))
  filter(χ -> occursin(".tsv", χ), _)
  replace.(".tsv" => "")
end

# iterate on files
for ƒ ∈ Symbol.(ł)
  @info ƒ
  global file = string(ƒ)
  @eval $ƒ = readdmnd(string(diamondDir, "/raw", "/", file, ".tsv"))

  @eval if size($ƒ, 1) > 0
    @eval scatterplot($ƒ[:, :pident] .|> Float64, $ƒ[:, :length] .|> Float64, xlim = (0, 100), ylim = (0, 1000)) |> println
  end


end

# sorting example
@chain begin
  Gorilla_gorilla_gorilla
  sort([:pident, :length], rev = true)
end

####################################################################################################

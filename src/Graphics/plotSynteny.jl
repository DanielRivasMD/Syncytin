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
  using CSV
  using DataFrames
  using RCall
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/evolutionaryCalculation.jl" ) )
  include( string( utilDir, "/fastaOperations.jl" ) )
  include( string( utilDir, "/ioDataFrame.jl" ) )
end;

################################################################################

# declare extract rows
norow = 3

# iterate on extracted annotations
for υ ∈ filter(χ -> contains(χ, "gene"), readdir(syntenyDir))
  @info υ

  annot = CSV.read( string( syntenyDir, "/", υ ), DataFrame )



  upstream = @chain annot begin
    filter(:distance => χ -> χ < 0, _)
    sort(:distance, rev = true)
    if size(_, 1) >= norow _[1:norow, :] else _[:, :] end
  end

  rdna = upstream[:, [:att_note, :start, :end, :strand]]
  rename!(rdna, :att_note => :name)







  # downstream = @chain annot begin
  #   filter(:distance => χ -> χ > 0, _)
  #   sort(:distance)
  # end




end

################################################################################

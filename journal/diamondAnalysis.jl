################################################################################

# project
projDir = "/Users/drivas/Factorem/Syncytin"

################################################################################

# load packages
begin
  using Pkg
  Pkg.activate(projDir)

  using DelimitedFiles
  using DataFrames
  using Plots
end

################################################################################

# load diamond output file
begin
  headers = ["qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore"] # default diamond headers
  crocro = DataFrame(readdlm(string(projDir, "/data/diamond/croCro.tsv")), headers)
end;

################################################################################

scatter(
  crocro.pident,
  crocro.length,
  markersize = 2,
  markercolor = :grey,
  ylim = (0, 2000),
  xlim = (0, 105),
  ylabel = "Alignment length",
  xlabel = "Percentage of identical matches",
  label = "Alignment records",
  title = "Diamond alignment Crocuta crocuta",
  dpi = 300,
)

################################################################################

plot!(
  Shape(
    [80, 105, 105, 80],
    [400, 400, 800, 800]
  ),
  opacity = 0.5,
  col = :red,
  label = "Selected space",
)

################################################################################

scatter(
  crocro.pident,
  crocro.length,
  markersize = 2,
  markercolor = :grey,
  ylim = (400, 800),
  xlim = (80, 105),
  ylabel = "Alignment length",
  xlabel = "Percentage of identical matches",
  label = "Alignment records",
  title = "Diamond alignment Crocuta crocuta [selected space]",
  dpi = 300,
)

################################################################################

function elipseShape(x, y, rx, ry)
  θ = LinRange(0, 2 * π, 500)
  y .+ ry * sin.(θ), x .+ rx * cos.(θ)
end

################################################################################

plot!(elipseShape(473, 90, 20, 10), seriestype = [:shape], col = :red, fillalpha = 0.5, label = "Carnivora") # Carnivora group
plot!(elipseShape(650, 98, 10, 2), seriestype = [:shape], col = :green, fillalpha = 0.5, label = "Hyaenidea") # Other Hyenas
plot!(elipseShape(498, 100, 8, 1), seriestype = [:shape], col = :blue, fillalpha = 0.5, label = "Crocuta crocuta") # Hyena Crocuta crocuta

################################################################################

crocroFilt = crocro |> p -> p[p.pident .> 80, :] |> p -> p[p.length .> 400, :]

################################################################################

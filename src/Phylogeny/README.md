Visualize results from **Exploration** in the phylogenetic context.

### Workflow

`alignmentPlot.jl` => parse results from diamond search.

`alignmentPlot.R` => plot results from diamond search.

`plotTree.jl` => concatenate taxonomy & alignment data.

`plotTree.R` => draw species phylogenetic tree & alignment information.

#### `taxonomy`

- `taxonomist.jl` => collect taxonomic output into dataframe & write to `/data/phylogeny/taxonomyDf.csv`.

- `taxonomist.sh` => retrieve taxnomic groups from assembly species using **`ncbi-taxonomist`**.

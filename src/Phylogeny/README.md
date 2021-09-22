Visualize results from **Exploration** in the phylogenetic context.

### Workflow

`alignmentPlot.jl` => parse results from diamond search.

`alignmentPlot.R` => plot results from diamond search.

`plotTree.R` => draw species phylogenetic tree & alignment information.

#### `taxonomy`

- `taxonomist.jl` => collect taxonomic output into dataframe.

- `taxonomist.sh` => retrieve taxnomic groups from assembly species using **`ncbi-taxonomist`**.

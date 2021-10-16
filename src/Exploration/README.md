Search for _syncitin_ sequences in assemblies.

### Workflow

`collectList.py` => scrap _wasabisys_ to collect information on available data.

`collectList.sh` => control `collectList.py`.

`retrieveAssemblies.sh` => collect **DNAzoo** assemblies from _wasabisys_ to _Pawsey_.

`curateAssemblyList.sh` => select assemblies to explore.

`insertionStats.sh` => collect general statistics on sequene similarity searches.

`insertionStats.R` => plot general statistics on sequence similarity searches results.

#### `blast`

- `genomeBlast.toml` => **`bender`** configuration for **`Assembly Search blast`**.

- `ncbi-blast.sh` => retrieve **`blast`** command line application.

#### `diamond`

- `genomeDiamond.toml` => **`bender`** configuration for **`Assembly Search diamond`**.

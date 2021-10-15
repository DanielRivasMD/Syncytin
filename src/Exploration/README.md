Search for _syncitin_ sequences in assemblies.

### Workflow

`collectList.py` => scrap _wasabisys_ to collect information on available data.

`assemblies.sh` => collect **DNAzoo** assemblies from _wasabisys_ to _Pawsey_.

`curateAssemblyList.sh` =>

#### `blast`

- `genomeBlast.toml` => **`bender`** configuration for **`Assembly Search blast`**.

- `ncbi-blast.sh` => retrieve **`blast`** command line application.

#### `diamond`

- `genomeDiamond.toml` => **`bender`** configuration for **`Assembly Search diamond`**.

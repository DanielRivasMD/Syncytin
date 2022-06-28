Search for _syncitin_ sequences in assemblies.

### Workflow

`collectList.py` => scrap _wasabisys_ to collect information on available data.

`collectList.sh` => control `collectList.py`.

`diamondDatabase.sh` => build database for **diamond**.

`diamondPerformance.sh` => performance test for **diamond** parameters.

`diamondSearch.sh` => search assemblies using **diamond**.

`diamondSegregate.sh` => segregate assembly scaffolds.

`filterAssemblies.sh` => filter scrapped assembly data.

`insertionStats.R` => plot general statistics on sequence similarity searches results.

`insertionStats.sh` => collect general statistics on sequence similarity searches.

`retrieveAssemblies.sh` => collect **DNAzoo** assemblies from _wasabisys_ to _Pawsey_.

#### `config`

- `diamond.toml` => **`bender`** configuration for **`assembly search diamond`**.

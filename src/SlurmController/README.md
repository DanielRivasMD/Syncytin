Control _SLURM_-managed cluster jobs.

### Workflow

`assemblies.sh` => collect **DNAzoo** assemblies from _wasabisys_ to _Pawsey_.

`genomeBlast.sh` => search for _syncytin_ sequences in assemblies through **BLAST** using **`bender`**.

`genomeDiamond.sh` => search for _syncytin_ sequences in assemblies through **diamond** using **`bender`**.

`jobTemplateSLURM.sh` => template for _SLURM_ jobs.

`syncytinConfigSLURM.sh` => _SLURM_ configuration at _Pawsey_, i.e., project ID, source & report forlders, assembly list.

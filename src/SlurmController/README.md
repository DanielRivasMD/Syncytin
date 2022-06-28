Control _SLURM_-managed cluster jobs.

### Workflow

`diamondDatabase.sh` => build database for _syncytin_ sequences through **diamond** using **`bender`**.

`diamondPerformance.sh` => performance test for **diamond** parameters using **`bender`**.

`diamondSearch.sh` => search for _syncytin_ sequences in assemblies through **diamond** using **`bender`**.

`diamondSegregate.sh` => segregate assembly scaffolds using **`bender`**.

`jobTemplateSLURM.sh` => template for _SLURM_ jobs.

`retrieveAssemblies.sh` => collect **DNAzoo** assemblies from _wasabisys_ to _Pawsey_.

`sequenceRetrieve.sh` => procure assemblies from _wasabisys_.

`syncytinConfigSLURM.sh` => _SLURM_ configuration at _Pawsey_, i.e., project ID, source & report forlders, assembly list.

`syntenyAlignment.sh` => perform syntenic alignment.

`syntenySatsuma.sh` => use **satsuma**.

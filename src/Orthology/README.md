Collect data on identified _syncitin_ loci.

### Workflow

`genomicPositions.jl` => collect best loci from filtered output & write to `/data/phylogeny/positionDf.csv`.

`genomicPositions.sh` => read **diamond** assembly search output & filter results.

`syntenyAnnotationRetrieve.sh` => read annotations & collect nearest gene to identified _syncytin_ loci.

`candidateSequenceRetrieve.sh` => extract candidate sequences from assemblies.

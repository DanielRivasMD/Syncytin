Collect data on identified _syncitin_ loci.

### Workflow

`genomicPositions.jl` => collect best loci from filtered output.

`genomicPositions.go` => read **diamond** assembly search output & filter results.

`genomicPositions.sh` => control `genomicPositions.go` executable.

`syntenyAnnotationRetrieve.go` => read annotations & collect nearest gene to identified _syncytin_ loci.

`syntenyAnnotationRetrieve.sh` => control `syntenyAnnotationRetrieve.go` executable.

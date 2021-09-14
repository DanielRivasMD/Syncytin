Computational study of _syncitin_ gene in vertebrates.

### Data description

`annoation` => **DNAzoo** assembly annotations.

`diamondOutput` => output from _diamond_ alignment. organized by assembly. also contains `taxonomist` data.

`DNAzoo` holds assemblies from **DNAzoo**.

`syncytinDB` holds all data related to syncytin annotations.

`accessionN` => nucleotide accessions.
`accessionP` => protein accessions.
`genBank` => genBank formatted accessions.
`nucleotide` => nucleotide library.
`protein` => protein library.

### Workflow

- [Collection](src/Collection/README.md): collect _syncytin_ sequences library.
- [Curation](src/Curation/README.md): cluster & curate _syncytin_ library.
- [Hydrophobicity](src/Hydrophobicity/README.md): measure _syncytin_ sequences hydrophobicity profile.
- [Exploration](src/Exploration/README.md): search for _syncytin_ cooptions in **DNAzoo** assemblies.
- [Orthology](src/Orthology/README.md): perform synteny alignment of identified _syncytin_ loci.
- [Phylogeny](src/Phylogeny/README.md): collect phylogenetic information & construct graphs.
- [Alignment](src/Alignment/README.md): perform multiple sequence alignment of library & identified _syncytin_ sequences.
- [Prediction](src/Prediction/README.md): calculate _syncytin_ sequences tridimensional structures.

Computational study of _syncitin_ gene in vertebrates.

### Archive

### Data description

#### `alignment`

concatenated fasta sequence for multiple sequence alignment.

#### `annoation`

**DNAzoo** assembly annotations.

#### `candidate`

collected candidate sequences from **DNAzoo** assemblies.

#### `diamondOutput`

output from _diamond_ alignment. organized by assembly. also contains `stats`

#### `DNAzoo`

hold assemblies from **DNAzoo**.

#### `insertion`

surroding sequences of the insertions candidate under the same nomemclature.

#### `phylogeny`

contain assembly lists & output from candidate loci & taxonomy.

#### `profile`

hydrophobicity profiles.

#### `synteny`

output from collecting candidate loci. organized by assembly.

#### `taxonomist`

hold taxonomy data per species.

#### `syncytinDB`

holds all data related to syncytin annotations.

- `accessionN` => nucleotide accessions.

- `accessionP` => protein accessions.

- `genBank` => genBank formatted accessions.

- `nucleotide` => nucleotide library.

- `protein` => protein library.

### Workflow

- [Collection](src/Collection/README.md): collect _syncytin_ sequences library.
- [Curation](src/Curation/README.md): cluster & curate _syncytin_ library.
- [Profile](src/Profile/README.md): measure _syncytin_ sequences hydrophobicity profile.
- [Exploration](src/Exploration/README.md): search for _syncytin_ cooptions in **DNAzoo** assemblies.
- [Orthology](src/Orthology/README.md): perform synteny alignment of identified _syncytin_ loci.
- [Phylogeny](src/Phylogeny/README.md): collect phylogenetic information & construct graphs.
- [Alignment](src/Alignment/README.md): perform multiple sequence alignment of library & identified _syncytin_ sequences.
- [Prediction](src/Prediction/README.md): calculate _syncytin_ sequences tridimensional structures.

[SlurmController](src/SlurmController/README.md) => control all jobs at _SLURM_-managed cluster.

[Utilities](src/Utilities/README.md) => provide functions.

TODO: retrieve syncytin candidate sequences
TODO: MSA carnivore conserved insertions & surroding sequences
TODO: MSA hyena alternative insertions
TODO: compare pre insertion loci accross orders, e.g., primates vs felines

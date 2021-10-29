Computational study of _syncitin_ gene in vertebrates.

### Archive

### Data description

#### `alignment` => concatenated fasta sequence for multiple sequence alignment.

#### `annoation` => **DNAzoo** assembly annotations.

#### `assembly` => information on assemblies.

#### `candidate` => collected candidate syncytin sequences from **DNAzoo** assemblies.

#### `diamondOutput` => output from _diamond_ alignment. organized by assembly. contain raw alignment & filter.

#### `DNAzoo` => hold assemblies from **DNAzoo**.

#### `insertion` => collected surrounding sequences of the candidate insertions under the same nomenclature.

#### `ncbiAssembly` => contain assemblies from NCBI.

#### `phylogeny` => contain assembly lists & output from candidate loci & taxonomy.

#### `prediction` => contain protein prediction data. contain training data & output.

#### `profile` => hydrophobicity profiles.

#### `stats` => collection of different statistics.

#### `synteny` => output from collecting candidate loci. organized by assembly.

#### `taxonomist` => hold taxonomy data per species.

#### `wasabi` => hold web scrapped data from _wasabisys_. contain raw scrapped data & filter for HiC assembly & annotation.

#### `syncytinDB` => hold all data related to syncytin annotations.

- `accessionN` => nucleotide accessions.

- `accessionP` => protein accessions.

- `genBank` => genBank formatted accessions.

- `nucleotide` => nucleotide library.

- `protein` => protein library.

### Source

- [Collection](src/Collection/README.md): collect _syncytin_ sequences library.
- [Curation](src/Curation/README.md): cluster & curate _syncytin_ library.
- [Profile](src/Profile/README.md): measure _syncytin_ sequences hydrophobicity profile.
- [Exploration](src/Exploration/README.md): search for _syncytin_ cooptions in **DNAzoo** assemblies.
- [Graphics](src/Graphics/README.md): collect phylogenetic information & construct graphs.
- [Orthology](src/Orthology/README.md): perform synteny alignment of identified _syncytin_ loci.
- [Alignment](src/Alignment/README.md): perform multiple sequence alignment of library & identified _syncytin_ sequences.
- [Prediction](src/Prediction/README.md): calculate _syncytin_ sequences tridimensional structures.
- [Taxonomy](src/Taxonomy/README.md):

[SlurmController](src/SlurmController/README.md) => control all jobs at _SLURM_-managed cluster.

[Utilities](src/Utilities/README.md) => provide functions.

### List

Contain version controlled data files as lists.

TODO: retrieve syncytin candidate sequences
TODO: MSA carnivore conserved insertions & surroding sequences
TODO: MSA hyena alternative insertions
TODO: compare pre insertion loci accross orders, e.g., primates vs felines

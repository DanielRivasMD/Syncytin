#!/bin/bash

# accession numbers annotated in references point to nucleotide sequences

# set variables
sync_proj="${HOME}/Factorem/Syncytin/"
sync_script="${sync_proj}Script/"
sync_ncbi="${sync_script}ncbiCollector/"
sync_dir="${sync_proj}Data/syncytins/"
sync_nucl="${sync_dir}nucleotide/"
sync_prot="${sync_dir}protein/"
sync_table="${sync_dir}featuretable/"


# format break
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡
DARK_GRAY='\033[1;30m'
NC='\033[0m'

echo ""
for i in {1..150};
do
  echo -n "${DARK_GRAY}‡${NC}"
done
echo ""
echo "\tFeature tables"
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡

# download feature tables
if [[ -f ${sync_table}syncytin_table.ft ]]
then
	echo -n "\tRemoving existing file: "
	rm -v ${sync_table}syncytin_table.ft
	echo ""
fi

cd ${sync_table}
while IFS=, read taxids syncytin_id reference
do
	ncbi-acc-download ${taxids} \
		--verbose \
		--format featuretable
	cat ${taxids}.ft >> ${sync_table}syncytin_table.ft
	rm -v ${taxids}.ft
done < ${sync_table}syncytin_source_table.csv
cd ${sync_proj}


# format break
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡
DARK_GRAY='\033[1;30m'
NC='\033[0m'

echo ""
for i in {1..150};
do
  echo -n "${DARK_GRAY}‡${NC}"
done
echo ""
echo "\tNucleotide sequences"
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡

# download nucleotide sequences
if [[ -f ${sync_nucl}syncytin_nucleotide.fa ]]
then
	echo -n "\tRemoving existing file: "
	rm -v ${sync_nucl}syncytin_nucleotide.fa
	echo ""
fi

cd ${sync_nucl}
while IFS=, read taxids syncytin_id reference
do
	ncbi-acc-download ${taxids} \
		--verbose \
		--format fasta \
		--molecule nucleotide
	cat ${taxids}.fa >> ${sync_nucl}syncytin_nucleotide.fa
	rm -v ${taxids}.fa
done < ${sync_table}syncytin_source_table.csv
cd ${sync_proj}


# format break
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡
DARK_GRAY='\033[1;30m'
NC='\033[0m'

echo ""
for i in {1..150};
do
  echo -n "${DARK_GRAY}‡${NC}"
done
echo ""
echo "\tProtein sequences"
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡

# download protein sequences
if [[ -f ${sync_prot}syncytin_prot.fa ]]
then
	echo -n "\tRemoving existing file: "
	rm -v ${sync_prot}syncytin_prot.fa
	echo ""
fi

# extract protein accession numbers from feature table
awk -f ${sync_ncbi}prot_acc_extract.awk ${sync_table}syncytin_table.ft > ${sync_table}syncytin_prot.csv

cd ${sync_prot}
while IFS=, read taxids syncytin_id reference
do
	ncbi-acc-download ${taxids} \
		--verbose \
		--format fasta \
		--molecule protein
	cat ${taxids}.fa >> ${sync_prot}syncytin_prot.fa
	rm -v ${taxids}.fa
done < ${sync_table}syncytin_prot.csv
cd ${sync_proj}

# format break
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡
DARK_GRAY='\033[1;30m'
NC='\033[0m'

for i in {1..150};
do
  echo -n "${DARK_GRAY}‡${NC}"
done
echo ""
#‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡

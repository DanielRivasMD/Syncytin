#!/bin/bash

# accession numbers annotated in references point to nucleotide sequences

# set variables
sync_proj="${HOME}/Factorem/Syncytin/"
sync_script="${sync_proj}Script/"
sync_geneS="${sync_script}geneSearch/"
sync_dir="${sync_proj}Data/syncytins/"
sync_nucl="${sync_dir}nucleotide/"
sync_prot="${sync_dir}protein/"
sync_table="${sync_dir}featuretable/"

# download feature tables
if [[ -f ${sync_table}syncytin_table.ft ]]
then
	rm -v ${sync_table}syncytin_table.ft
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


# download nucleotide sequences
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


# download protein sequences
cd ${sync_prot}
awk -f ${sync_geneS}prot_acc_extract.awk ${sync_table}syncytin_table.ft > ${sync_table}syncytin_prot.csv

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



#while IFS=, read taxids syncytin_id reference
# TODO: gather all Accession numbers (genes & proteins) and download in batch


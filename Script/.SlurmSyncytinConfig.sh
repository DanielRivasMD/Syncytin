#!/bin/bash

#------------------------------------------------------------------------------------------------------------------------------

# project
#computing_cluster="snowy"
#computing_cluster="rackham"
project_id="snic2020-15-35"

#------------------------------------------------------------------------------------------------------------------------------

## prefixes & sufixes
#spp="chlSab"
#EV_XV="_ERV_${spp}_XV"
#COM="_compilation"
#CH="_chimeric"
#ANCH="_to_anchor"
#trash="_to_be_terminated"
#P_C="precomp/"

#------------------------------------------------------------------------------------------------------------------------------

## files
#REF_GEN="${spp}2.fa"
#REF_EV_XV="REF_${spp}.fa"

#------------------------------------------------------------------------------------------------------------------------------

## alignments
#which_align[0]=""
#which_align[1]="_R1"
#which_align[2]="_R2"

#------------------------------------------------------------------------------------------------------------------------------

## directories
#DRIVAS="/home/drivas/"
#SCRIPT_BIN_folder="${DRIVAS}Factorem/Script/"
#SCRIPT_folder="${DRIVAS}Factorem/Vervet/Script/"
#SCRIPT_RUNALL="${SCRIPT_folder}RA00/"
#PROJ_DB_folder="${DRIVAS}private/Vervet/db_list/"
#DATA_folder="${DRIVAS}private/Vervet/Data/"
#REPORT_BIN_folder="${DRIVAS}Factorem/Report/"
#REPORT_folder="${DRIVAS}Factorem/Vervet/Report/"
#BWA_Data_folder="${DRIVAS}Factorem/Data/"
#TARBALL_folder="${DRIVAS}private/Vervet/tarballs_backup/"
#STORAGE_folder="${DRIVAS}private/Vervet/bams_tempo/"
#SRA_folder="${DRIVAS}private/Vervet/sra_tempo/"
#SRA_ADDRESS="${DRIVAS}private/storage_rackham_ERV/ERV_Vervet_green_monkey/SRA/sra/"
#EXTRACT_LOCUS="${DRIVAS}private/Vervet/extract_locus/"
#SQL_DB="${DRIVAS}private/Vervet/SQL_DB/"
#GO_EXECUTABLES="${SCRIPT_folder}GoWorkshop/Executables/"

#------------------------------------------------------------------------------------------------------------------------------

## numeric variables
#b_read_lenght=100
#b_bwa_def_seed=19
#b_erv_inside_seq=10
#b_mapq=20
#b_insert_dist=400
#b_pos_margin=1000
#no_chr=29
#no_vervet_inds=$( awk 'END{print NR}' ${PROJ_DB_folder}Wild_list.txt )
#no_vervet_runs=$( awk 'END{print NR}' ${PROJ_DB_folder}WildLog.txt )
#no_vervet_groups=$( awk 'END{print NR}' ${PROJ_DB_folder}WildTaxons.txt )

# #------------------------------------------------------------------------------------------------------------------------------
#
# # numeric variables jackknifing
# jk_ir_array=({2..8})
# jk_add_array=({10,12,15,20,25})
# jk_array=("${jk_ir_array[@]}" "${jk_add_array[@]}")
# triplics=3
#
# super_jk_ir_array=({1..10})
# super_jk_add_array=({15,20,25,30,35,40,45,50,60,70,80,90,100,150,200,250,300,350,400,450,500})
# super_jk_array=("${jk_ir_array[@]}" "${jk_add_array[@]}")
# super_triplics=1
#
# #------------------------------------------------------------------------------------------------------------------------------

# bash array
JOB_ARRAY_PREFIX="NO_BASH_ARRAY"

#------------------------------------------------------------------------------------------------------------------------------

# make temporary directory
if [[ "${SNIC_TMP}" != "/scratch" ]]
then
  TMP_DIR="${SNIC_TMP}/${SLURMD_NODENAME}_${SLURM_JOBID}/"
  mkdir ${TMP_DIR}
fi

#------------------------------------------------------------------------------------------------------------------------------

# report format
report_break="\n#------------------------------------------------------------------------------------------------------------------------------\n"
val1="-30s"
val2="14.3f"
awk_report_format="%${val1} -> %${val2}\n"
go_report_format="%${val1} -> %${val2}%s"
dr_awk_val1="-70s"
dr_awk_val2="40s"
data_retrieve_awk_report_format="%${dr_awk_val1} -> %${dr_awk_val2}\n"

#------------------------------------------------------------------------------------------------------------------------------

#if [[ "$LIST_PREFIX" == "Wild" ]]
#then
#  paired_switch=1
#  single_switch=1
#  ervaln_switch=1
#elif [[ "$LIST_PREFIX" == "Colony" ]]
#then
#  paired_switch=0
#  single_switch=1
#  ervaln_switch=1
#fi

#------------------------------------------------------------------------------------------------------------------------------

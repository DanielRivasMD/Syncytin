#!/bin/bash

#------------------------------------------------------------------------------------------------------------------------------

# project
computing_cluster="snowy"
#computing_cluster="rackham"
project_id="snic2020-15-35"

#------------------------------------------------------------------------------------------------------------------------------

# prefixes & sufixes

#------------------------------------------------------------------------------------------------------------------------------

# files

#------------------------------------------------------------------------------------------------------------------------------

# alignments

#------------------------------------------------------------------------------------------------------------------------------

# directories
DRIVAS="/home/drivas/"
SCRIPT_BIN_folder="${DRIVAS}Factorem/Script/"
SCRIPT_folder="${DRIVAS}Factorem/Syncytin/Script/"
DATA_folder="${DRIVAS}private/Syncytin/Data/"
DNAzoo="${DATA_folder}DNAzoo/"
REPORT_BIN_folder="${DRIVAS}Factorem/Report/"
REPORT_folder="${DRIVAS}Factorem/Syncytin/Report/"
SRA_folder="${DRIVAS}private/Syncytin/sra_tmp/"
SRA_ADDRESS="${DRIVAS}private/Syncytin/SRA/sra/"
GO_EXECUTABLES="${SCRIPT_folder}GoWorkshop/Executables/"

#------------------------------------------------------------------------------------------------------------------------------

# numeric variables

#------------------------------------------------------------------------------------------------------------------------------

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

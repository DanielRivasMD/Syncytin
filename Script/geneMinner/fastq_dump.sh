#!/bin/bash

#------------------------------------------------------------------------------------------------------------------------------

# load variables
source /home/drivas/Factorem/Syncytin/Script/.SlurmSyncytinConfig.sh

# load modules
module load \
  bioinfo-tools \
  sratools



#------------------------------------------------------------------------------------------------------------------------------

# collect slurm head
source ${SCRIPT_BIN_folder}slurm_head_hunter.sh

#------------------------------------------------------------------------------------------------------------------------------

# test file
test_sra="SRR8616936.sra"

#------------------------------------------------------------------------------------------------------------------------------

# test fastq dumping with hardcoded values
fastq-dump \
  -v \
  -O ${SRA_folder} \
  ${SRA_ADDRESS}${test_sra} 2>> ${ERR_FILE}

#------------------------------------------------------------------------------------------------------------------------------

# # test fastq dumping controller
# source /home/drivas/Factorem/Syncytin/Script/.SlurmSyncytinConfig.sh
#
# sbatch \
#   --clusters ${computing_cluster} \
#   --account ${project_id} \
#   --job-name SRA_fastq_dump \
#   --output ${REPORT_folder}SRA_fastq_dump.output \
#   --error ${REPORT_folder}SRA_fastq_dump.err \
#   --time 240:0:0 \
#   --partition core \
#   --ntasks 1 \
#   --export log_file="SRA_fastq_dump" \
#   ${SCRIPT_folder}geneMinner/fastq_dump.sh

#------------------------------------------------------------------------------------------------------------------------------

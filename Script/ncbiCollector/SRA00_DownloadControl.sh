#!/bin/bash

#------------------------------------------------------------------------------------------------------------------------------

# LOAD VARIABLES
source /home/drivas/Factorem/Syncytin/Script/.SlurmSyncytinConfig.sh

#------------------------------------------------------------------------------------------------------------------------------
#
#      888b    888  .d88888b. 88888888888 8888888888 .d8888b.
#      8888b   888 d88P" "Y88b    888     888       d88P  Y88b
#      88888b  888 888     888    888     888       Y88b.
#      888Y88b 888 888     888    888     8888888    "Y888b.
#      888 Y88b888 888     888    888     888           "Y88b.
#      888  Y88888 888     888    888     888             "888
#      888   Y8888 Y88b. .d88P    888     888       Y88b  d88P
#      888    Y888  "Y88888P"     888     8888888888 "Y8888P"
#
#------------------------------------------------------------------------------------------------------------------------------

: <<- 'NOTES'
`sratools` provides a toolbox for dealing with files in SRA.

SRA toolkit configuration => https://github.com/ncbi/sra-tools/wiki/05.-Toolkit-Configuration

	once `sra-tools` are loaded at Uppmax, configuration file can be found at: "/sw/bioinfo/sratools/2.9.6-1/rackham/bin/vdb-config"

	to edit enter `./vdb-config --interactive`

	configuration will be saved at "/home/drivas/.ncbi/syncytin-settings.mkfg" & soft-linked to "/home/drivas/.ncbi/user-settings.mkfg"

tools use in these scripts include:

  `vdb-config`. tool to configure SRA settings.

  `prefetch --max-size 35G 'SRA_ID'`. tool for downloading SRA files according to especified configuration. where `--max-size` indicates the limit size of files to download. default in 20G. IMPORTANT: it also provides builtin check for files' existant.

  `vdb-validate 'SRA_ID'`. tool for verifying files' integrity. analog to `checksum`.

  `fastq-dump -v --outdir 'OUTPUT_DIRECTORY' --split-files 'SRA_ID'`. tool for rebuilding binary SRA files into FASTQ. where `--outdir` especifies path where files will be assambled, and `--split-files` indicates reads will be reconstituted in different files.
NOTES

#------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------

# SRA01_00, downloads SRA binaries for DNA zoo Hi-C
SRA01_00_id=$( sbatch \
  --clusters ${computing_cluster} \
  --account ${project_id} \
  --job-name SRA01_DNAzoo \
  --output ${REPORT_folder}SRA01_DNAzoo.output \
  --error ${REPORT_folder}SRA01_DNAzoo.err \
  --time 240:0:0 \
  --partition core \
  --ntasks 1 \
  --export log_file="DNAzoo" \
  ${SCRIPT_folder}ncbiCollector/SRA-A_FastqDownload.sh | egrep -o -e "\b[0-9]+" )

#------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
#
#      8888888888 888b    888 8888888b.
#      888        8888b   888 888  "Y88b
#      888        88888b  888 888    888
#      8888888    888Y88b 888 888    888
#      888        888 Y88b888 888    888
#      888        888  Y88888 888    888
#      888        888   Y8888 888  .d88P
#      8888888888 888    Y888 8888888P"
#
#------------------------------------------------------------------------------------------------------------------------------

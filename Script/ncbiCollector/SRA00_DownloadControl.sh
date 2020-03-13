#!/bin/bash

#------------------------------------------------------------------------------------------------------------------------------

# LOAD VARIABLES
source /home/drivas/Factorem/Vervet/Script/RA00/chlSabConfig.sh

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
"sratools" provides a toolbox for dealing with files in SRA.
tools use in these scripts include:

  "vdb-config". tool to configure SRA settings.

  "prefetch --max-size 35G 'SRA_ID'". tool for downloading SRA files according to especified configuration. where '--max-size' indicates the limit size of files to download. default in 20G. IMPORTANT: it also provides builtin check for files' existant.

  "vdb-validate 'SRA_ID'". tool for verifying files' integrity. analog to 'checksum'.

  "fastq-dump -v --outdir 'OUTPUT_DIRECTORY' --split-files 'SRA_ID'. tool for rebuilding binary SRA files into FASTQ. where '--outdir' especifies path where files will be assambled, and '--split-files' indicates reads will be reconstituted in different files.
NOTES

#------------------------------------------------------------------------------------------------------------------------------
#
#       .d8888b.  8888888b.         d8888  .d8888b.   d888
#      d88P  Y88b 888   Y88b       d88888 d88P  Y88b d8888
#      Y88b.      888    888      d88P888 888    888   888
#       "Y888b.   888   d88P     d88P 888 888    888   888
#          "Y88b. 8888888P"     d88P  888 888    888   888
#            "888 888 T88b     d88P   888 888    888   888
#      Y88b  d88P 888  T88b   d8888888888 Y88b  d88P   888
#       "Y8888P"  888   T88b d88P     888  "Y8888P"  8888888
#
#------------------------------------------------------------------------------------------------------------------------------
#
#           .d8888b.           888       888 8888888 888      8888888b.       8888888b.   .d88888b.  8888888b.   .d8888b.
#          d88P  Y88b          888   o   888   888   888      888  "Y88b      888   Y88b d88P" "Y88b 888   Y88b d88P  Y88b
#          888    888          888  d8b  888   888   888      888    888      888    888 888     888 888    888 Y88b.
#          888    888 d8b      888 d888b 888   888   888      888    888      888   d88P 888     888 888   d88P  "Y888b.
#          888    888 Y8P      888d88888b888   888   888      888    888      8888888P"  888     888 8888888P"      "Y88b.
#          888    888          88888P Y88888   888   888      888    888      888        888     888 888              "888
#          Y88b  d88P d8b      8888P   Y8888   888   888      888  .d88P      888        Y88b. .d88P 888        Y88b  d88P
#           "Y8888P"  Y8P      888P     Y888 8888888 88888888 8888888P"       888         "Y88888P"  888         "Y8888P"
#
#------------------------------------------------------------------------------------------------------------------------------

# SRA01_00, downloads SRA binaries for Wild Populations
SRA01_00_id=$( sbatch \
  --clusters $computing_cluster \
  --account $project_id \
  --job-name SRA01_WildPopulations \
  --output ${REPORT_folder}SRA01_WildPopulations.output \
  --error ${REPORT_folder}SRA01_WildPopulations.err \
  --time 240:0:0 \
  --partition core \
  --ntasks 1 \
  --export log_file="WildLog" \
  ${SCRIPT_folder}FastqDownload/SRA-A_FastqDownload.sh | egrep -o -e "\b[0-9]+" )

#------------------------------------------------------------------------------------------------------------------------------
#
#       .d8888b.  8888888b.         d8888  .d8888b.   .d8888b.
#      d88P  Y88b 888   Y88b       d88888 d88P  Y88b d88P  Y88b
#      Y88b.      888    888      d88P888 888    888        888
#       "Y888b.   888   d88P     d88P 888 888    888      .d88P
#          "Y88b. 8888888P"     d88P  888 888    888  .od888P"
#            "888 888 T88b     d88P   888 888    888 d88P"
#      Y88b  d88P 888  T88b   d8888888888 Y88b  d88P 888"
#       "Y8888P"  888   T88b d88P     888  "Y8888P"  888888888
#
#------------------------------------------------------------------------------------------------------------------------------
#
#           .d8888b.            .d8888b.   .d88888b.  888      .d88888b.  888b    888 Y88b   d88P
#          d88P  Y88b          d88P  Y88b d88P" "Y88b 888     d88P" "Y88b 8888b   888  Y88b d88P
#          888    888          888    888 888     888 888     888     888 88888b  888   Y88o88P
#          888    888 d8b      888        888     888 888     888     888 888Y88b 888    Y888P
#          888    888 Y8P      888        888     888 888     888     888 888 Y88b888     888
#          888    888          888    888 888     888 888     888     888 888  Y88888     888
#          Y88b  d88P d8b      Y88b  d88P Y88b. .d88P 888     Y88b. .d88P 888   Y8888     888
#           "Y8888P"  Y8P       "Y8888P"   "Y88888P"  88888888 "Y88888P"  888    Y888     888
#
#------------------------------------------------------------------------------------------------------------------------------

# SRA02_00, downloads SRA binaries for Research Colony
SRA02_00_id=$( sbatch \
  --clusters $computing_cluster \
  --account $project_id \
  --job-name SRA02_ResearchColony \
  --output ${REPORT_folder}SRA02_ResearchColony.output \
  --error ${REPORT_folder}SRA02_ResearchColony.err \
  --time 240:0:0 \
  --partition core \
  --ntasks 1 \
  --export log_file="ColonyLog" \
  ${SCRIPT_folder}FastqDownload/SRA-A_FastqDownload.sh | egrep -o -e "\b[0-9]+" )

#------------------------------------------------------------------------------------------------------------------------------
#
#       .d8888b.  8888888b.         d8888  .d8888b.   .d8888b.
#      d88P  Y88b 888   Y88b       d88888 d88P  Y88b d88P  Y88b
#      Y88b.      888    888      d88P888 888    888      .d88P
#       "Y888b.   888   d88P     d88P 888 888    888     8888"
#          "Y88b. 8888888P"     d88P  888 888    888      "Y8b.
#            "888 888 T88b     d88P   888 888    888 888    888
#      Y88b  d88P 888  T88b   d8888888888 Y88b  d88P Y88b  d88P
#      "Y8888P"  888   T88b d88P     888  "Y8888P"   "Y8888P"
#
#------------------------------------------------------------------------------------------------------------------------------
#
#           .d8888b.           888b    888 8888888888 888       888       .d8888b.   .d88888b.  888      .d88888b.  888b    888 Y88b   d88P
#          d88P  Y88b          8888b   888 888        888   o   888      d88P  Y88b d88P" "Y88b 888     d88P" "Y88b 8888b   888  Y88b d88P
#          888    888          88888b  888 888        888  d8b  888      888    888 888     888 888     888     888 88888b  888   Y88o88P
#          888    888 d8b      888Y88b 888 8888888    888 d888b 888      888        888     888 888     888     888 888Y88b 888    Y888P
#          888    888 Y8P      888 Y88b888 888        888d88888b888      888        888     888 888     888     888 888 Y88b888     888
#          888    888          888  Y88888 888        88888P Y88888      888    888 888     888 888     888     888 888  Y88888     888
#          Y88b  d88P d8b      888   Y8888 888        8888P   Y8888      Y88b  d88P Y88b. .d88P 888     Y88b. .d88P 888   Y8888     888
#           "Y8888P"  Y8P      888    Y888 8888888888 888P     Y888       "Y8888P"   "Y88888P"  88888888 "Y88888P"  888    Y888     888
#
#------------------------------------------------------------------------------------------------------------------------------

# SRA03_00, downloads SRA binaries for New Colony
SRA03_00_id=$( sbatch \
  --clusters $computing_cluster \
  --account $project_id \
  --job-name SRA03_NewColony \
  --output ${REPORT_folder}SRA03_NewColony.output \
  --error ${REPORT_folder}SRA03_NewColony.err \
  --time 240:0:0 \
  --partition core \
  --ntasks 1 \
  --export log_file="NewColonyLog" \
  ${SCRIPT_folder}FastqDownload/SRA-A_FastqDownload.sh | egrep -o -e "\b[0-9]+" )

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

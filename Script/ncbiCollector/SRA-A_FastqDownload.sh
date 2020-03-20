#!/bin/bash

#------------------------------------------------------------------------------------------------------------------------------

# LOAD VARIABLES
source /home/drivas/Factorem/Syncytin/Script/.SlurmSyncytinConfig.sh

# LOAD MODULES
module load \
	bioinfo-tools \
	sratools/2.9.6-1



#------------------------------------------------------------------------------------------------------------------------------

# BASH ARRAY


JOB_ARRAY_PREFIX="SRA-A_FastqDownload"

# COLLECT SLURM HEAD
source ${SCRIPT_BIN_folder}slurm_head_hunter.sh

#------------------------------------------------------------------------------------------------------------------------------

# control log
FQDownloadLog="${REPORT_folder}${log_file}_${SLURMD_NODENAME}_${SLURM_JOBID}.log"

# verify data base directory
if [[ $( readlink ${HOME}/.ncbi/user-settings.mkfg ) != "syncytin-settings.mkfg" ]]
then
	echo "Verify data base directory" >> ${ERR_FILE}

	scancel ${SLURM_JOBID}
fi

#------------------------------------------------------------------------------------------------------------------------------

# initiate error_array
while read ID
do
  (( id_count++ ))
  error_array[$id_count]=${ID}
done < ${DNAzoo}${log_file}.txt

#------------------------------------------------------------------------------------------------------------------------------

# error_array iterartion
max_its=11
while [[ ${#error_array[@]} != 0 ]] && (( it_count < max_its ))
do
  # control iterartions as max_its
  (( it_count++ ))
  echo -e "${report_break}\tIteration count: ${it_count}\n\tArray length: ${#error_array[@]}${report_break}" >> ${OUT_FILE}

  # itirate using the present indexes rather that the length of the array
  for ix in "${!error_array[@]}"
  do
    # fetch sra file
    fetch_check=$( prefetch --max-size 100G ${error_array[$ix]} | tee -a ${OUT_FILE} 2>> ${ERR_FILE} )

    if [[ "${fetch_check}" =~ "failed to download" ]]
    then
        echo "${error_array[$ix]} Fail at ${it_count}" >> ${FQDownloadLog}
    elif [[ "${fetch_check}" =~ "downloaded successfully" ]] || [[ ${fetch_check} =~ "found locally" ]]
    then
      check_check=$( vdb-validate ${error_array[$ix]} 2>&1 | tee -a ${OUT_FILE} 2>> ${ERR_FILE} )

      # check download
      if [[ "${check_check}" =~ "consistent" ]]
      then
        echo "${error_array[$ix]} Pass at ${it_count}" >> ${FQDownloadLog}
        unset 'error_array[$ix]'
      fi
    fi
  done
done

#------------------------------------------------------------------------------------------------------------------------------

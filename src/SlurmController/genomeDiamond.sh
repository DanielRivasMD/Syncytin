#!/bin/bash

source ${HOME}/Factorem/Syncytin/src/SlurmController/Syncytin_slurmConfig.sh
jobId=SyncytinDiamond

################################################################################

sbatch \
  --account ${projectId} \
  --partition workq \
  --job-name ${jobId} \
  --output ${reportFolder}/${jobId}.out \
  --error ${reportFolder}/${jobId}.err \
  --time 24:0:0 \
  --nodes 1 \
  --ntasks 4 \
  --export sourceFolder=${sourceFolder},curatedAssembly=${curatedAssembly} \
  --array 1-30 \
  --wrap \
  'bender AssemblySearch diamond \
  --configPath ${sourceFolder}/src/diamond/ \
  --configFile genomeDiamond.toml \
  --species $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f1 ) \
  --assembly $( sed -n "$SLURM_ARRAY_TASK_ID"p "${curatedAssembly}" | cut -d " " -f2 )'

# --array 1-$( awk 'END{print NR}' ${curatedAssembly} ) \
  #'gzip -dc Crocuta_crocuta_HiC.fasta.gz | diamond blastx -d syncytinLibraryProt.dmnd -q - -o croCro.tsv'

################################################################################e

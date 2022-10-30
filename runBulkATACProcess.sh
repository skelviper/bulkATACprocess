#!/bin/bash

#usage: ./runBulkATACProcess.sh

cd ../
mkdir -p slurm_log
snakemake --use-conda --cluster 'sbatch --exclude node03 --qos=medium --output=slurm_log/slurm-%j.out --cpus-per-task={threads} -t 7-00:00 -J ATAC!' --jobs 180 --resources nodes=180 --rerun-incomplete -s ./bulkATACprocess/atac.smk --keep-going

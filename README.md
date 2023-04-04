# bulkATACprocess
Preprocess bulk cut&amp;tag or atac seq data with double insertion, adapt from JWY

if use the inhouse version, plase use the following command to install the environment

```bash
mamba create -n atac -c conda-forge -c bioconda python=3.8 snakemake=5.20.1 bwa-mem2 macs2 samtools picard
```

to run the inhouse version pipeline, run

```bash
cd bulkATACprocess; ./runbulkATACprocessInhouse.sh
```
import os

samples = ["STCTac_fixed"]

rule all:
    input:
        bam = expand("processed/bam/{sample}.sort.bam",sample=samples),
        bw = expand("processed/bw/{sample}.sort.dedup.bw",sample=samples),
        narrowPeak = expand("processed/peak/{sample}_peaks.xls",sample=samples)


rule bwa_map:
    input:
        R1 = "Rawdata/{sample}/{sample}_R1.fq.gz",
        R2 = "Rawdata/{sample}/{sample}_R2.fq.gz",
    output:
        bam = "processed/bam/{sample}.sort.bam",
    threads: 10
    params:
        index = "/share/Data/public/ref_genome/GRCh37d5/bwa_mem2_index/genome.fa",
    shell:"""
        bwa-mem2 mem -t7 {params.index} {input.R1} {input.R2} | samtools sort -@3 -o {output.bam}
    """

rule picard_dedup:
    input:
        bam = rules.bwa_map.output.bam,
    output:
        bam = "processed/bam/{sample}.sort.dedup.bam",
    shell:"""
        picard MarkDuplicates -I {input.bam} -O {output.bam} -M processed/bam/{wildcards.sample}.dedup.metrics.txt --REMOVE_DUPLICATES true --ASSUME_SORT_ORDER coordinate
        samtools index {output.bam}
    """

rule remove_blacklist:
    input:
        bam = rules.picard_dedup.output.bam,
    output:
        bam = "processed/bam/{sample}.sort.dedup.blacklist.bam",
    params:
        blacklist = "/share/Data/public/ref_genome/GRCh37d5/ENCODE_blacklist/ENCFF356LFX.bed",
    shell:"""
        bedtools intersect -v -abam {input.bam} -b {params.blacklist} > {output.bam}
    """

rule bam2bw:
    input:
        bam = "processed/bam/{sample}.sort.dedup.bam",
    output:
        bw = "processed/bw/{sample}.sort.dedup.bw",
    shell:"""
        bamCoverage -b {input.bam} -o {output.bw} --binSize 100 --normalizeUsing RPKM --effectiveGenomeSize 2652783500 --extendReads 150
    """

rule macs2_callpeak:
    input:
        bam = "processed/bam/{sample}.sort.dedup.bam",
    output:
        narrowPeak = "processed/peak/{sample}_peaks.xls",
    params:
        control = "processed/bam/STCTac_fixed.sort.dedup.bam",
    shell:"""
        # macs2 call peak for H3K27ac
        macs2 callpeak -t {input.bam} -f BAMPE -g hs -n {wildcards.sample} --nomodel --nolambda --outdir processed/peak
    """

# rule calculate_FRIP:
#     input:
#         bam = "processed/bam/{sample}.sort.dedup.bam",
#         narrowPeak = "processed/peak/{sample}.narrowPeak",
#     output:
#         FRIP = "processed/peak/{sample}.FRIP.txt",
#     shell:"""
#         python3 /share/Data/public/softwares/FRIP/FRIP.py -i {input.bam} -p {input.narrowPeak} -o {output.FRIP}
#     """


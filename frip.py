# calculate frip score for each sample
# frip = (number of reads in peaks) / (number of reads in the sample)
# input  : bam file, peak file
# output : frip score

def calc_frip(bam, peak):
    import pysam
    import pybedtools
    import numpy as np
    import pandas as pd

    # read bam file
    bam = pysam.AlignmentFile(bam, 'rb')
    # read peak file
    peak = pybedtools.BedTool(peak)
    # calculate number of reads in peaks
    n_reads_in_peaks = peak.intersect(bam, c=True).to_dataframe().iloc[:, 3].sum()
    # calculate number of reads in the sample
    n_reads_in_sample = bam.count()
    # calculate frip score
    frip = n_reads_in_peaks / n_reads_in_sample
    return frip

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--bam', help='bam file')
    parser.add_argument('-p', '--peak', help='peak file')
    args = parser.parse_args()
    frip = calc_frip(args.bam, args.peak)
    print(frip)

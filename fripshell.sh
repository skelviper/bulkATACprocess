# args1 is bam and args2 is peak
# fripshell.sh ./processed/ct_all/CT1.ct.pairend.sort.bam ./processed/ct_all/CT1.ct.pairend.sort.bed


#bam行数
ct_bam_file="./processed/ct_all/${ct}.ct.pairend.sort.bam"
# ct_bam_file="./processed/ct_all/${ct}.ct.R2.sort.bam"
ct_bam_line=`samtools view -c ${ct_bam_file}`

#和peak的交集有多少行

ct_intersect=`bedtools sort -i ${ct_peak_file} | bedtools merge -i stdin | bedtools intersect -u -nonamecheck -a ${ct_bam_file} -b stdin -ubam | samtools view -c`

#计算frip
ct_frip=`echo "scale=4;${ct_intersect}/${ct_bam_line}" | bc`

#写入./stat/ct_frip.txt文件
echo -e "${ct}\t${ct_frip}" >> ./stat/ct_frip.txt
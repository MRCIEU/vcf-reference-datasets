#!/bin/bash

mkdir -p 1000g_filtered
cd 1000g_filtered

module add apps/bcftools-1.9-74/1.9-74

# Get dataset
wget -O ld_files.tgz https://www.dropbox.com/s/yuo7htp80hizigy/ld_files.tgz?dl=0
tar xzcf ld_files.tgz
rm ld_files.tgz

# Get frequencies
plink --bfile ../ref/data_maf0.01_rs --freq gz --out ../ref/data_maf0.01_rs

# Create single file
paste <(cat ../ref/data_maf0.01_rs.bim) <(zcat ../ref/data_maf0.01_rs.frq.gz | sed 1d | awk '{ print $5'}) | gzip -c > ../ref/data_maf0.01_rs.txt.gz

# Create vcf
cat ../ref/meta.txt <(zcat ../ref/data_maf0.01_rs.txt.gz | awk 'BEGIN {print "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO"} {print $1"\t"$4"\t"$2"\t"$6"\t"$5"\t.\tPASS\tAF="$7}') | bcftools view -Ob -o ../ref/data_maf0.01_rs.bcf

# index
bcftools index ../ref/data_maf0.01_rs.bcf


######

# As above but keep only biallelic SNPs (no indels)
awk '{ if (($5 == "A" || $5 == "T" || $5 == "C" || $5=="G") && ($6 == "A" || $6 == "T" || $6 == "C" || $6=="G"))
        print $2 }' ../ref/data_maf0.01_rs.bim > snps

plink --bfile ../ref/data_maf0.01_rs --extract snps --make-bed --out ../ref/data_maf0.01_rs_snps

rm snps

plink --bfile ../ref/data_maf0.01_rs_snps --freq --out ../ref/data_maf0.01_rs_snps
gzip ../ref/data_maf0.01_rs_snps.frq

paste <(cat data_maf0.01_rs_snps.bim) <(zcat data_maf0.01_rs_snps.frq.gz | sed 1d | awk '{ print $5'}) | gzip -c > data_maf0.01_rs_snps.txt.gz


cat ../ref/meta.txt <(zcat ../ref/data_maf0.01_rs_snps.txt.gz | awk 'BEGIN {print "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO"} {print $1"\t"$4"\t"$2"\t"$6"\t"$5"\t.\tPASS\tAF="$7}') | bcftools view -Ob -o ../ref/data_maf0.01_rs_snps.bcf

bcftools index ../ref/data_maf0.01_rs_snps.bcf




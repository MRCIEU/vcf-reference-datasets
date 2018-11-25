#!/bin/bash
mkdir -p dbsnp
cd dbsnp

# Note we can also use dbSNP which has ALT allele frequencies
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/All_20180418.vcf.gz

# Or dbSNP filter of only common variants
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/common_all_20180418.vcf.gz
# Though this is slightly prooblematic because they have a CAF column instead of a standard AF column, 
# so handling multiallelic SNPs won't automatically handle this column




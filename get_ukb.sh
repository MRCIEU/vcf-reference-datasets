#!/bin/bash

set -e

mkdir -p ukb
cd ukb

wget http://s3.amazonaws.com/plink2-assets/plink2_linux_x86_64_20181028.zip
unzip plink2_linux_x86_64_20181028.zip
zcat ~/mr-eve/gwas-instrument-subsets/studies/UKB-b\:100/elastic.gz | cut -f 1 > snplist.txt
head -n 2000 ~/data/bbimp/derived/ancestry/data.europeans.txt > keeplist.txt

for i in {1..22}
do
ii=`printf "%02d" $i`
./plink2 --bgen ~/data/bbimp/dosage_bgen/data.chr$ii.bgen --sample ~/data/bbimp/data.sample --extract snplist.txt --keep keeplist.txt --make-bed --out extract$i
done

echo "extract2" > mergelist.txt
for i in {3..22}
do
	echo "extract$i" >> mergelist.txt
done

plink --bfile extract1 --merge-list mergelist --make-bed --out ukb_ref

rm extract*



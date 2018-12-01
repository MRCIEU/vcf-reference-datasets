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


for i in {1..22}
do
	cat extract$i.bim | cut -f 2 | sort | uniq -c | sed 's/^ *//' | grep -v ^1 | cut -d " " -f 2 > temp$i
	wc -l temp$i
	plink --bfile extract$i --exclude temp$i --make-bed --out extract${i}_nomult
done


#for i in {1..22}
#do
#	mv extract$i.bim extract$i.bim.orig
#	awk 'BEGIN {OFS="\t"} { print $1, $1":"$4"_"$5"->"$6, $3, $4, $5, $6}' extract$i.bim.orig > extract$i.bim
#	paste <(cut -f 2 extract$i.bim.orig) extract$i.bim > rs_ids$i.txt
#done


echo "extract2_nomult" > mergelist.txt
for i in {3..22}
do
	echo "extract${i}_nomult" >> mergelist.txt
done

plink --bfile extract1_nomult --merge-list mergelist --make-bed --out ukb_ref

# rm extract*



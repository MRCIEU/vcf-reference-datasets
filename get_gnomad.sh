#!/bin/bash

module add Python/2.7.11-foss-2016a

mkdir -p gnomad
cd gnomad

~/bin/gsutil/gsutil cp gs://gnomad-public/release/2.1/vcf/genomes/gnomad.genomes.r2.1.sites.vcf.bgz .
~/bin/gsutil/gsutil cp gs://gnomad-public/release/2.1/vcf/genomes/gnomad.genomes.r2.1.sites.vcf.bgz.tbi .
bcftools annotate -x ^INFO/AF gnomad.genomes.r2.1.sites.vcf.bgz -Ob -o gnomad.genomes.r2.1.sites.af.bcf
bcftools index gnomad.genomes.r2.1.sites.af.bcf


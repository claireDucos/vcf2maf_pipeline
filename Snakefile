import snakemake.utils  # Load snakemake API
import glob
import os



SAMPLES=[]

sample_id_list = glob.glob('vcf/*.vcf')
for name in sample_id_list:
    SAMPLES.append(name.split('.')[0].split('/')[1].split('_')[0])

include : "rules/vcf2csv.smk"
include : "rules/add_col.smk"
include : "rules/separate_ensembl.smk"
include: "rules/merge_maf.smk"
include : "rules/gzip.smk"




rule all:
    input:
         "final_maf.csv"
    message:
        "Finishing the VCF2MAF pipeline"

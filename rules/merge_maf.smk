"""
This delete the colname
"""
rule delete_col_name:
    input:
        "results/{sample}_ens_sep.csv"
    output:
        temp("results/{sample}.csv")
    message:
        "delete first line {wildcards.sample}"
    threads:
        4
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(128 * attempt, 512)
        )
    log:
        "logs/{sample}.vcf.log"

    shell:
         """sed '1d' {input} |  sed 's/ /\t/g' > {output}"""
"""
This rule takes all the file and merged them into an only csv file
"""
rule merge_maf:
    input:
        expand("results/{sample}.csv", sample=SAMPLES)
    output:
        temp("final_maf_no_name.csv")
    message:
        "merge all maf"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcards, attempt: min(attempt * 2048, 20480)
        )
    log:
        "logs/merge"

    shell:
         "cat {input} | sort | uniq > {output} "

"""
This rule add the correct_col name
"""
rule add_colnames_final:
    input:
        "final_maf_no_name.csv"
    output:
        "final_maf.csv"
    message:
        "tyu"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(128 * attempt, 512)
        )
    log:
        "logs/merge"

    shell:
        "sed '1s/.*/Hugo_symbol Entrez_Gene_Id Center NCBI_Build Chromosome Start_Position End_Position Strand Variant_Classification Variant_Type Reference_Allele Tumor_Seq_Allele1 Tumor_Seq_Allele2 dbSNP_RS dbSNP_Val_Status Tumor_Sample_Barcode Matched_Norm_Seq_Allele1 Match_Norm_Seq_Allele2 Tumor_Validation_Allele1 Tumor_Validation_Allele2 Match_Norm_Validation_Allele Match_Norm_Validation_Allele2 Verification_Status Validation_Status Mutation_Status Sequencing_Phase Sequence_Source Validation_Method Score BAM_File Sequencer HGVSc  HGVSp Exon_number Gene Feature Feature_type cDNA_position CDS_position protein_position SIFT PolyPhen PubMed AN AC AF DP set/' {input} > {output}"


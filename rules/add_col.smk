"""
This rule add th 3th column of a maf file : Center
"""
rule add_center:
    input:
        "snpsift/{sample}.csv"
    output:
        temp("add/{sample}_center.csv")
    message:
        "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.vcf.log"

    shell:
         """awk '$2 = $2 FS "CNRGH"' {input} > {output}"""

"""
This rule add th 4th column of a maf file : NCBI_Build
"""
rule add_NCBI_Build:
    input:
        "add/{sample}_center.csv"
    output:
        temp("add/{sample}_ncbi_build.csv")
    message:
        "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.vcf.log"

    shell:
         """awk '$3 = $3 FS "GRCh37"' {input}  > {output}"""

"""
This rule add th 7th column of a maf file : end_position
"""
rule add_end_position:
    input:
        "add/{sample}_ncbi_build.csv"
    output:
        temp("add/{sample}_end_pos.csv")
    message:
        "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.log"

    shell :
        """python script/end_pos.py {input} > {output}"""

"""
This rule add the 8th column of a maf file : strand
"""
rule add_strand:
    input:
        "add/{sample}_end_pos.csv"
    output:
        temp("add/{sample}_strand.csv")
    message:
        "Add col : {wildcards.sample}"
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
       "logs/add/{sample}.log"

    shell:
         """sed '$d' {input} | awk '$7 = $7 FS "+"' > {output}"""

"""
This rule add the 13th column of a maf file : tum_2or_seq_allele
"""
rule add_tumor_seq_allele_2:
    input:
        "add/{sample}_strand.csv"
    output:
        temp("add/{sample}_tum_all_2.csv")
    message:
        "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.log"

    shell:
         """awk '$12 = $12 FS "."' {input} > {output}"""

"""
This rule add the 15th column of a maf file : strand
"""
rule add_dbSNP_Val_Status:
    input:
        "add/{sample}_tum_all_2.csv"
    output:
        temp("add/{sample}_dbsnp_val.csv")
    message:
       "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.log"

    shell:
         """awk '$14 = $14 FS "NULL"' {input} > {output}"""

"""
This rule add the 16th column of a maf file : sample ID
"""
rule add_sample_ID:
    input:
        "add/{sample}_dbsnp_val.csv"
    output:
        temp("add/{sample}_sampleID.csv")
    message:
        "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.log"

    shell:
         """awk '$15 = $15 FS "{wildcards.sample}"' {input} > {output}"""

"""
This rule add the last columns of a maf file : 17 à 32
"""
rule add_last:
    input:
        "add/{sample}_sampleID.csv"
    output:
        temp("add/{sample}_last.csv")
    message:
       "Add col : {wildcards.sample}"
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
        "logs/add/{sample}.log"

    shell:
         """awk '$16 = $16 FS "."' {input} | awk '$17 = $17 FS "NULL"' | awk '$18 = $18 FS "NULL"' | awk '$19 = $19 FS "NULL"' | \
            awk '$20 = $20 FS "NULL"' | awk '$21 = $21 FS "NULL"' | awk '$22 = $22 FS "NULL"' | awk '$23 = $23 FS "Unknown"' | \
            awk '$24 = $24 FS "Untested"' | awk '$25 = $25 FS "Untested"' | awk '$26 = $26 FS "NULL"' | awk '$27 = $27 FS "WXS"' | \
            awk '$28 = $28 FS "None"' | awk '$29 = $29 FS "NULL"' | awk '$30 = $30 FS "None"' | \
            awk '$31 = $31 FS "Illumina_HiSeq"' > {output}"""

"""
This rule add the correct_col name
"""
rule add_colnames:
    input:
        "add/{sample}_last.csv"
    output:
        temp("add/{sample}_col_name.csv")
    message:
        "Add col name : {wildcards.sample}"
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
        "logs/add/{sample}.log"

    shell:
        "sed '1s/.*/Hugo_symbol Entrez_Gene_Id Center NCBI_Build Chromosome Start_Position End_Position Strand Variant_Classification Variant_Type Reference_Allele Tumor_Seq_Allele1 Tumor_Seq_Allele2 dbSNP_RS dbSNP_Val_Status Tumor_Sample_Barcode Matched_Norm_Seq_Allele1 Match_Norm_Seq_Allele2 Tumor_Validation_Allele1 Tumor_Validation_Allele2 Match_Norm_Validation_Allele Match_Norm_Validation_Allele2 Verifiaction_Status Validation_Status Mutation_Status Sequencing_Phase Sequence_Source Validation_Method Score BAM_File Sequencer  HGVSc  HGVSp Exon_number Gene Feature Feature_type cDNA_position CDS_position protein_position SIFT PolyPhen PubMed AN AC AF DP set /' {input} > {output}"


"""
This rule replace all the space by tabulation
"""
rule replace_space_by_tab:
    input:
        "add/{sample}_col_name.csv"
    output:
        "add/{sample}_final.csv"
    message:
        "Add col on {wildcards.sample}"
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
        "logs/add/{sample}.log"
    shell:
        """tr ' ' '\t' <{input} >{output} """




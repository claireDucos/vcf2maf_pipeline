"""
Get the line with two  ENSEMBL ID
"""
rule separate_ensembl:
    input:
        "add/{sample}_final.csv"
    output:
        "ens/{sample}_2delete.csv"
    message:
        "Separate ENSEMBL ID : {wildcards.sample}"
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
        "logs/ensembl/{sample}.log"

    shell:
         """
         sh script/ens_doublons.sh {input} > {output}
         """


"""
Split the line with two ensembl ID
"""
rule convert_ensmble2entrez:
    input:
        line_delete="ens/{sample}_2delete.csv",
        csv="add/{sample}_final.csv"
    output:
        "results/{sample}_ens_sep.csv"
    message:
        "Convert ENSEMBL_id to ENTREZ_ID : {wildcards.sample}"
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
        "logs/ensembl/{sample}.log"

    shell:
         """
         sh script/split_ens.sh {input.csv} {input.line_delete} > {output}
         """



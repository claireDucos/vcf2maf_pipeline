rule decompress_vcf:
    input:
        "vcf/{sample}.vcf.gz"
    output:
        temp("vcf/{sample}.vcf")
    message:
        "decompress {wildcards.sample}"
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
        "logs/compress/{sample}.vcf.log"
    shell:
        "pbgzip -d {input} -f > {output}"
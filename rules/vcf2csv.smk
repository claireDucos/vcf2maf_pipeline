"""
This rule takes any vcf file, and transform it in a csv file
"""
rule transform_vcf_to_csv:
    input:
        "vcf/{sample}.vcf"
    output:
        "snpsift/{sample}.csv"
    message:
        "Using SnpSift ExtractFields : {wildcards.sample}"
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
        "logs/extract_fields/{sample}.vcf.log"

    shell:
         "cat {input} | script/vcfEffOnePerLine.pl | java -jar ~/anaconda3/envs/vcf2maf/share/snpsift-4.3.1t-2/SnpSift.jar extractFields -s ',' -e '.' - 'ANN[*].GENE' 'ANN[*].GENEID' 'CHROM' 'POS' 'ANN[*].EFFECT' 'VARTYPE' \
           'REF' 'ALT' 'ID' 'ANN[*].HGVS_C' 'ANN[*].HGVS_P' 'ANN[*].RANK' 'ANN[*].GENEID' 'ANN[*].TRID' 'ANN[*].FEATURE' 'ANN[*].CDNA_POS' 'ANN[*].CDS_POS' 'ANN[*].AA_POS' \
           'dbNSFP_SIFT_pred[*]' 'dbNSFP_Polyphen2_HDIV_pred' 'GWASCAT_PUBMED_ID' \
           'AN' 'AC' 'AF' 'DP' 'set' > {output} 2> {log} "





# 1 Gene name
# 2 Gene ID : AP
# 3 Center : AP
# 4 NCBI_build : AP
# 5 Chromosome
# 6 Start_position
# 7 End_position : AP
#8 Strand : AP ==> faire lien entre sense du gène et gtf pour avoir cette info
# 9 Variant classification
# 10 Variant type
# 11 Reference allele
# 12 Tumor seq allele 1
# 13 Tumor seq allele 2 = AP mettre un point partout
# 14 dbSNP_RS : c'est tout les rs
# 15 dbSNP-val-stat : AP
# 16  à 25 tu peux pas remplir je crois

# 28 : WES

# 35 HGVSc 	The coding sequence of the variant in HGVS recommended format
# 36 HGVSp 	The protein sequence of the variant in HGVS recommended format. "p.=" signifies no change in the protein
# 37 HGVSp_Short
# 38 Transcript ID

# 48 ANN.GENEID
# 49 ANN.FEATUREID
# 50 ANN.FEATURE
# 51 ANN.EFFECT
# 52 ANN.EFFECT AUSSI?
# 53 cDNA_position 	Relative position of base pair in the cDNA sequence as a fraction. A "-" symbol is displayed as the numerator if the variant does not appear in cDNA
# 54 CDS_position 	Relative position of base pair in coding sequence. A "-" symbol is displayed as the numerator if the variant does not appear in coding sequence
# 55 Protein_position

# !!! 69 - SWISSPROT 	  UniProtKB/Swiss-Prot accession
# !!! 70 - TREMBL 	UniProtKB/TrEMBL identifier of protein product
# !!! 71 - UNIPARC 	UniParc identifier of protein product
# !!! 72 - RefSeq
# 73 SIFT
# 74 PolyPhen

# 78 - GMAF 	Non-reference allele and frequency of existing variant in 1000 Genomes
# 79 - AFR_MAF 	Non-reference allele and frequency of existing variant in 1000 Genomes combined African population
# 80 - AMR_MAF 	Non-reference allele and frequency of existing variant in 1000 Genomes combined American population
# 81 - ASN_MAF 	Non-reference allele and frequency of existing variant in 1000 Genomes combined Asian population
# !!!!!!! 82 - EAS_MAF 	Non-reference allele and frequency of existing variant in 1000 Genomes combined East Asian population
# 83 - EUR_MAF 	Non-reference allele and frequency of existing variant in 1000 Genomes combined European population
# !!!!!!!! 84 - SAS_MAF

# 89 PubMed ID

# 101 - ExAC_AF 	Global Allele Frequency from   ExAC
# 102 - ExAC_AF_Adj 	Adjusted Global Allele Frequency from ExAC
# 103 - ExAC_AF_AFR 	African/African American Allele Frequency from ExAC
# 104 - ExAC_AF_AMR 	American Allele Frequency from ExAC
# 105 - ExAC_AF_EAS 	East Asian Allele Frequency from ExAC
# 106 - ExAC_AF_FIN 	Finnish Allele Frequency from ExAC
# 107 - ExAC_AF_NFE 	Non-Finnish European Allele Frequency from ExAC

# 109 - ExAC_AF_SAS 	South Asian Allele Frequency from ExAC






#Question plus bio : là on a 11 var d'un meme gène = 11 lignes, déjà est ce que ça veut dire 11 allèles de ce meme gène et est ce qu'on conserve els 11 lignes ou il faut en faire une seule ??

"""
RP11-206L10.4	ENSG00000229905	1	756298	upstream_gene_variant	SNP	A	C	n.-4613A>C	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758144	upstream_gene_variant	SNP	A	G	n.-2767A>G	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758324	upstream_gene_variant	SNP	T	C	n.-2587T>C	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758877	upstream_gene_variant	SNP	C	A	n.-2034C>A	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758897	upstream_gene_variant	SNP	C	G	n.-2014C>G	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758933	upstream_gene_variant	SNP	C	G	n.-1978C>G	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758940	upstream_gene_variant	SNP	A	T	n.-1971A>T	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758948	upstream_gene_variant	SNP	T	A	n.-1963T>A	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758953	upstream_gene_variant	SNP	A	C	n.-1958A>C	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758954	upstream_gene_variant	SNP	T	C	n.-1957T>C	.	ENST00000422528.1	-1	-1	-1	-1	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.	.
RP11-206L10.4	ENSG00000229905	1	758955	upstream_gene_variant	SNP	A	C	n.-1956A>C	.	ENST00000422528.1	-1	-1	-1	-1	
"""
#Q : dans un premier temps quels sont les colonnes essentielles
#Q2 : Je m'embrouille dans les colonnes du mAF sachant que nous on a pas sample N et T ?
#Q3 : énormément d'annotation impact (notamment quand on regarde le html rapport) qui sont MODIFIER, j'ai du mal à comprendre extactement ce que c'est
         # (genre nul ou pas) et si c'est "normal" d'en avoir autant.
#Q4 : en général plusieurs effets (plusieurs ANN sep par) on fait comment :
         #- un ann = une ligne
         #- tout sur une ligne dans la meme col?

# Q5 : quel polyphen HDIV ou HVAR

# Q6 : jamais d'info sur les pop afre, ase, fin ect

"""(java -jar ~/anaconda3/envs/vcf2maf/share/snpsift-4.3.1t-2/SnpSift.jar extractFields -s ',' -e '.' {input} 'ANN[0].GENE' 'ANN[0].GENEID' 'CHROM' 'POS' 'ANN[0].EFFECT' 'VARTYPE' \
           'REF' 'ALT' 'ID' 'ANN[0].HGVS_C' 'ANN[0].HGVS_P' 'ANN[0].TRID' 'ANN[0].RANK' 'ANN[0].CDNA_POS' 'ANN[0].CDS_POS' 'ANN[0].AA_POS' \
           'dbNSFP_Polyphen2_HDIV_pred' 'dbNSFP_SIFT_pred[0]' 'GWASCAT_PUBMED_ID' \
           'dbNSFP_ExAC_AF' 'dbNSFP_ExAC_Adj_AF' 'dbNSFP_ExAC_AFR_AF' 'dbNSFP_ExAC_AMR_AF' \
           'dbNSFP_ExAC_EAS_AF' 'dbNSFP_ExAC_FIN_AF' 'dbNSFP_ExAC_NFE_AF' 'dbNSFP_ExAC_SAS_AF' \
           'dbNSFP_1000Gp1_AF' 'dbNSFP_1000Gp1_AFR_AF' 'dbNSFP_1000Gp1_AMR_AF' 'dbNSFP_1000Gp1_ASN_AF' \
           'dbNSFP_1000Gp1_EUR_AF' > {output}) 2> {log} "
"""
# VCF2MAF : transformer les fichier vcf en un fichier maf

Cette pipeline Snakemake permet de transformer les fichiers au format vcf en un fichier au format maf (mutation annotation format).

En entrée prend tous les vcfs, préalablement filtrés (liste de gènes / couverture / IC), et en sortie, on obtient un seul et unique maf.

Ce fichier MAF est pris en entrée de la pipeline filtre_count_variant, qui permet de compter le nombre de fois où un variant est retrouvé chez tous les individus et de ne sélectionner que ceux présent chez moins de 400.

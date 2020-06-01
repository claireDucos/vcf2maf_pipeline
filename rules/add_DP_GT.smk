"""
This rule takes a CSV file with info GT from many vc, and add a DP mean col
"""
import pandas as pd

rule add_DP_mean:
    input:
        "results/{sample}.csv"
    output:
        "results/{sample}_dp.csv"
    message:
        "add dp mean col to {wildcards.sample}"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(8 * attempt, 15)
        )

    run:
        df = pd.read_csv(input[0], sep='\t')
        filter_col = [col for col in df if col.endswith('.DP')]  # select the DP col (one per VC)
        DP_df = df[filter_col]
        mean_list = []  # will contain all the averages to add to the dataframe
        for line in df.index:
            numerator = 0
            denominator = 0
            for col in DP_df.columns:
                if df[col][line] != '.':
                    denominator += 1
                    numerator += int(df[col][line])
            if denominator == 0:
                mean_list.append('.')
            else:
                mean_list.append(round(numerator / denominator))
        df['DP_mean'] = mean_list
        output[0] = df.to_csv(input[0].split('.')[0]+'_dp.csv', sep='\t')





"""
This rule takes a CSV file with info GT from many vc, and add a GT consensus column
"""
import pandas as pd

rule add_GT_consensus:
    input:
        "results/{sample}_dp.csv"
    output:
        "results/{sample}_final.csv"
    message:
        "add GT col to {wildcards.sample}"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(8 * attempt, 15)
        )

    run:
        df = pd.read_csv(input[0], sep='\t')
        filter_col = [col for col in df if col.endswith('.GT')]  # select the GT col (one per VC)
        GT_df = df[filter_col]
        GT_max = []

        for line in df.index:
            dic_GT = {'0/0': 0, '0/1': 0, '1/0': 0, '1/1': 0}
            for col in GT_df:
                for key in dic_GT.keys():
                    if df[col][line] == key:
                        dic_GT[key] += 1
            max_key = max(dic_GT, key=dic_GT.get)
            GT_max.append(max_key)

        df['GT_mean'] = GT_max
        output[0] = df.to_csv(input[0].split('_')[0]+'_final.csv', sep='\t')
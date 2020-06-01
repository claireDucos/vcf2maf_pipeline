import pandas as pd
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("infile")
args = parser.parse_args()

file=args.infile

df = pd.read_csv(file, sep=' ')

end_list = []

for line in df.itertuples():
    end_pos=0
    if (line.VARTYPE == 'MNP'):
        end_pos=line.POS+len(line.ALT)-1
        end_list.append(end_pos)
    else: # SNP/ DEL/ INS
        end_list.append(line.POS)

df.insert(6, "End_pos", end_list, True)

print(df.to_csv(index=False,sep='\t'))





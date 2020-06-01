#!/bin/bash
uniq $1 | grep -v -f $2 | awk '$2~"-"{a=split($1,hug,"-"); b=split($2,ens,"-");c=split($36,ensbis,"-"); for (i=1;i<=b;i++) {$1=hug[i];$2=ens[i];$36=ensbis[i]; print};next}1'

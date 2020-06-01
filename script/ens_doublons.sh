#!/bin/bash
awk '$1~"-"{n=split($1,a,"-");for (i=1;i<=n;i++) {if(i>2) {print $0}}}'  $1 | uniq

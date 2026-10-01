#!/usr/bin/env bash

# activate conda env with mafft first
mkdir ../data/final_uces_70p_aligned

for i in $(ls ../data/final_uces70p/*fasta); do
    mafft --thread 20 --auto $i > ../data/final_uces_70p_aligned/aligned_`basename $i`
done

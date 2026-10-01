#!/usr/bin/env bash

# activate the environment containing iqtree3
# combinado_uces_otocephala is the directory with the aligned fasta files for the uces
# the output is a single file with one MLE for each gene tree.
iqtree3 -S combinado_uces_otocephala --prefix gene_trees/loci -T 40

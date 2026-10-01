#!/usr/bin/env bash

# don't forget to use tree-qmc for inferring the initial tree using quartets
tree-qmc \
    -i ../data/loci_subsampled_taxa_steindach_phracto.tre \
    -o ../data/otocephala_subsampled_taxa_steindach_phracto_init_tree.tre

# reroot at Gyrinocheilus_aymonieri_LBPV_114225
pxrr \
    -t ../data/otocephala_subsampled_taxa_steindach_phracto_init_tree.tre \
    -g Gyrinocheilus_aymonieri_LBPV_114225 \
    -o ../data/otocephala_subsampled_taxa_steindach_phracto_init_tree_rerooted.tre 

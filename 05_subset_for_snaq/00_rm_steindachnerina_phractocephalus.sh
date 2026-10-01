#!/usr/bin/env bash

# activate phyx
# don't forget to activate the conda env where phyx lives
pxrmt -t ../data/loci_no_lepisosteus.tre \
      -f ../subsample_taxa_clean_steindach_phracto \
      -c \
      -o ../data/loci_subsampled_taxa_steindach_phracto.tre

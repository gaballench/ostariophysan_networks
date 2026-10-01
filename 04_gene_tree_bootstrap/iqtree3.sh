#!/bin/bash

# estimate the gene tree with iqtree3
iqtree3 -s $1 --prefix $1 -T AUTO -ntmax 10 -B 1000 --boot-trees

# compress the ufboot file only
tar cvfz $1.tar.gz $1.ufboot

# cleanup unnecessary output files as well as input seq file before compression
rm *.bionj \
   *.ckp.gz \
   *.contree \
   *.iqtree \
   *.log \
   *.mldist \
   *.model.gz \
   *.splits.nex \
   *.treefile \
   *.ufboot \
   *.phy \
   $1

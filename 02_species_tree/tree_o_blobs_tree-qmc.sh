# activate the tree-qmc env and do not install phyx in it, call the global version

# first remove all Lepisosteus to root only at Amia
pxrmt \
    -t ../data/gene_trees/loci.treefile \
    -n lepisosteus_oculatus \
    -o loci_no_lepisosteus.tre

# then reroot all gts because the tutorial gts were rooted
pxrr \
    -t loci_no_lepisosteus.tre \
    -g amia_ocellicauda \
    -o loci_no_lepisosteus_rooted.newick 

# estimate the base tree, but do not root it
tree-qmc \
    -i loci_no_lepisosteus.tre \
    -o otocephala_base_tree.tre

# root the base tree with phyx
pxrr \
    -t otocephala_base_tree.tre \
    -g amia_ocellicauda \
    -o otocephala_base_tree_rerooted.tre 

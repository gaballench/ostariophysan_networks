# activate the tree-qmc env and do not install phyx in it, call the global version

# do exhaustive psearch, check the log file, and see that most of the very low pvalues with possible signal of reticulation are 
# limit iterations to 1/4 taxnum squared = (232/4)^2 = 3364 because this is a big dataset
tree-qmc \
    --blobsearchonly otocephala_base_tree_rerooted.tre \
    --store_pvalue \
    --3f1a \
    --iter_limit_blob 3364 \
    -i loci_no_lepisosteus.tre \
    -o otocephala_psearch_exhaustive_limit3364_3f1a.tre &> otocephala_psearch_exhaustive_limit3364_3f1a.log

# filter only the branch id, tree- and star-p-values, and qCF
grep \
    -e "branch id [0-9]*, QTT: [0-9.e-]*; QST: [0-9.e-]*; qCF: \[[0-9]*/[0-9]*/[0-9]*\]; ngts: [0-9]*; ratio 2 smallest qCFs: [0-9.nainf-]*" \
    -o \
    otocephala_psearch_exhaustive_limit3364_diagnostics.log > otocephala_psearch_exhaustive_limit3364_diagnostics_pvals_qcfs.txt


# then use alpha = 1e-6 and beta 0.95 as cutoff for collapsing branches in the base tree, this is the tree of blobs
tree-qmc \
    --alpha 1e-7 \
    --beta 0.95 \
    --load_pvalue \
    -i otocephala_psearch_exhaustive_limit3364_diagnostics.tre \
    -o otocephala_psearch_exhaustive_limit3364_diagnostics_a1e-7_b0.95_tob.tre

tree-qmc \
    --alpha 1e-11 \
    --beta 0.95 \
    --load_pvalue \
    -i otocephala_psearch_exhaustive_limit3364_diagnostics.tre \
    -o otocephala_psearch_exhaustive_limit3364_diagnostics_a1e-11_b0.95_tob.tre

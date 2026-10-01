#!/usr/bin/env bash

### real input for a single run
CFTABLE="CFs_with_CIs_otocephala_wo_steinphracto.csv"
TREE="otocephala_bestnet_h4_nosteinphracto_outgroup_clean_prop0.1_logmoves.tre"
OUTNAME="bootsnaq_otocephala_nosteinphracto"

### arguments to pass to estimation_snaq.jl:
#- cf_table: Path to the CF table. A string.
#- init_tree: Path to the initial tree. A string.
#- out_name: Prefix for the results. A string.
#- outgroup: Which taxon to enforce as outgroup. A string
#- hmax: Maximum number of hybrid edges. An integer
#- propQuartets: Proportion of quartets to subsample for fast inference. A float.
#- probQR: Probability of proposing moves relative to uncertainty in quartets. A float.
#- seed: Whether to enforce the explicit sampling of a seed. A boolean.
#- myseed: If not using an automatic seed, which one to use. An integer.

# v1 is because after replacement it becomes e.g. v1 or vX
julia --threads 10 bootsnaq_v1.jl $CFTABLE \
    $TREE \
    $OUTNAME \
    Gyrinocheilus_aymonieri_LBPV_114225 \
    4 \
    0.1 \
    1.0 \
    true \
    0

# remove the input files to reduce file size
rm $CFTABLE
rm $TREE
rm bootsnaq_v1.jl

# compress SNaQ's output only
tar cvfz $1.tar.gz "$OUTNAME"*

# remove output files and dirs and leave only the compressed one
rm -r "$OUTNAME"*

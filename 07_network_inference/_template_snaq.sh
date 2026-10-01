#!/usr/bin/env bash

### real input for a single run
CFTABLE="cftablefield"
TREE="treefield"
OUTNAME="outnamefield"
LOGOUTNAME="outnamefield_log_"

### arguments to pass to estimation_snaq.jl:
#- cf_table: Path to the CF table. A string.
#- init_tree: Path to the initial tree. A string.
#- out_name: Prefix for the results. A string.
#- logout_name: Prefix for the log of moves. A string.
#- outgroup: Which taxon to enforce as outgroup. A string
#- hmax: Maximum number of hybrid edges. An integer
#- qinfTest: Whether to clean uninformative quartets in the proportion 0.333:0.3333:0.3333. A boolean.
#- propQuartets: Proportion of quartets to subsample for fast inference. A float.
#- probQR: Probability of proposing moves relative to uncertainty in quartets. A float.
#- seed: Whether to enforce the explicit sampling of a seed. A boolean.
#- myseed: If not using an automatic seed, which one to use. An integer.
#- verbose: Whether to pass verbose as true to snaq. A string.

# vversionfield is because after replacement it becomes e.g. v1 or vX
julia --threads 10 estimation_snaq_vversionfield.jl $CFTABLE \
    $TREE \
    $OUTNAME \
    $LOGOUTNAME \
    outgroupfield \
    hfield \
    true \
    0.1 \
    1.0 \
    true \
    0 \
    true

# remove the input files to reduce file size
rm $CFTABLE
rm $TREE
rm estimation_snaq_vversionfield.jl

# compress SNaQ's output only
tar cvfz $1.tar.gz "$OUTNAME"*

# remove output files and dirs and leave only the compressed one
rm -r "$OUTNAME"*

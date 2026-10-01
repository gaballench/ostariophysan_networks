"""
estimation_snaq.jl

Run snaq on command-line arguments, CF data, 
and an initial topology

This script takes ten arguments, which are in 
their respective order:

- cf_table: Path to the CF table. A string.
- init_tree: Path to the initial tree. A string.
- out_name: Prefix for the results. A string.
- logout_name: Prefix for the log of moves. A string.
- outgroup: Which taxon to enforce as outgroup. A string
- hmax: Maximum number of hybrid edges. An integer
- qinfTest: Whether to clean uninformative quartets in the proportion 0.333:0.3333:0.3333. A boolean.
- propQuartets: Proportion of quartets to subsample for fast inference. A float.
- probQR: Probability of proposing moves relative to uncertainty in quartets. A float.
- seed: Whether to enforce the explicit sampling of a seed. A boolean.
- myseed: If not using an automatic seed, which one to use. An integer.
- verbose: Whether to pass verbose as true to snaq. A string.

Usage: 

julia estimation_snaq.jl cf_table 
    init_tree 
    out_name 
    logout_name 
    outgroup 
    hmax 
    qinfTest 
    propQuartets 
    probQR 
    seed 
    myseed 
    verbose
"""

using PhyloNetworks
using SNaQ
using CSV
using Random

# use arguments for feeding tree and cfs
cf_table = ARGS[1]
init_tree = ARGS[2]
out_name = ARGS[3]
logout_name = ARGS[4]
outg = ARGS[5]
h = parse(Int, ARGS[6])
qinf = parse(Bool, ARGS[7])
propQuart = parse(Float64, ARGS[8])
probMoves = parse(Float64, ARGS[9])
seedbool = parse(Bool, ARGS[10])
myseed = parse(Int, ARGS[11])
verb = parse(Bool, ARGS[12])

if seedbool
    seednum = rand(1:10000000)
else
    seednum = myseed
end

# read the concordance factor table
cfs = readtableCF(cf_table)

# read starting tree
start_tree = readnewick(init_tree)

rootatnode!(start_tree, outg)

# estimate a network
net = snaq!(start_tree, cfs, hmax=h, filename=out_name, logprefix=logout_name, verbose=verb, runs = 1, outgroup=outg, propQuartets=propQuart, qinfTest=qinf, probQR=probMoves, seed=seednum)

#exit julia
exit()
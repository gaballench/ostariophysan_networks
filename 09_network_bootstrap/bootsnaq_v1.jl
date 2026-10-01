"""
bootsnaq.jl

Run snaq on command-line arguments, CF data, 
and an initial topology

This script takes ten arguments, which are in 
their respective order:

- cf_table: Path to the CF table. A string.
- init_tree: Path to the initial tree. A string.
- filename: Prefix for the results. A string.
- outgroup: Which taxon to enforce as outgroup. A string
- hmax: Maximum number of hybrid edges. An integer
- propQuartets: Proportion of quartets to subsample for fast inference. A float.
- probQR: Probability of proposing moves relative to uncertainty in quartets. A float.
- seed: Whether to enforce the explicit sampling of a seed. A boolean.
- myseed: If not using an automatic seed, which one to use. An integer.

Usage: 

julia bootsnaq.jl cf_table 
    init_tree 
    file_name 
    outgroup 
    hmax 
    propQuartets 
    probQR 
    seed 
    myseed 
"""

using PhyloNetworks
using SNaQ
using CSV
using DataFrames
using Random

# use arguments for feeding tree and cfs
cf_table = ARGS[1]
init_tree = ARGS[2]
file_name = ARGS[3]
outg = ARGS[4]
h = parse(Int, ARGS[5])
propQuart = parse(Float64, ARGS[6])
probMoves = parse(Float64, ARGS[7])
seedbool = parse(Bool, ARGS[8])
myseed = parse(Int, ARGS[9])

if seedbool
    seednum = rand(1:10000000)
else
    seednum = myseed
end

# read the concordance factor table
cfs = CSV.read(cf_table, DataFrame)

# read starting tree
start_tree = readnewick(init_tree)

rootatnode!(start_tree, outg)

# estimate a network
bootnet = bootsnaq(start_tree, cfs, hmax=h, filename=file_name, nrep = 1, runs = 1, outgroup=outg, propQuartets=propQuart, probQR=probMoves, seed=seednum)

#exit julia
exit()
# note that SNaQ >=v1.2.0 must be used so that the function confintqCF_genetrees  
using SNaQ, PhyloNetworks, CSV, DataFrames

cd("/home/gaballench/otocephala_networks/gene_tree_bootstrap/wo_steinphracto/code")

gtmles = "../mlegts/loci_subsampled_taxa_steindach_phracto.tre"
gtboots = "../bootgts/wo_steinphracto_bootgts"

cfwcis = confintqCF_genetrees(gtmles, gtboots, 0.95, true);

CSV.write("../results/CFs_with_CIs_otocephala_wo_steinphracto.csv", cfwcis)

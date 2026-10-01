using SNaQ
using PhyloNetworks
using PhyloPlots
using StatsPlots
using StatsBase
using HypothesisTests
using FreqTables
using DataFrames
using RCall
# This also needs tbea >=v1.8.0 in R

# function for calculating the pairwise mu distance between nets
function mudist_pairwise(nets)
    dM = zeros(Int64, length(nets), length(nets))
    for i in 1:(length(nets)-1)
        for j in (i+1):length(nets)
            dM[i,j] = dM[j,i] = PhyloNetworks.mudistance_rooted(nets[i], nets[j])
        end
    end
    return dM
end

function rfdist_pairwise(nets, rooted)
    dM = zeros(Int64, length(nets), length(nets))
    for i in 1:(length(nets)-1)
        for j in (i+1):length(nets)
            dM[i,j] = dM[j,i] = PhyloNetworks.hardwiredclusterdistance(nets[i], nets[j], rooted)
        end
    end
    return dM
end

iterdirs = readdir("../h4_outgroup_clean_prop0.1_logmoves/uncompressed/")

# first network to initialise the vector
nets = [readsnaqnetwork("../h4_outgroup_clean_prop0.1_logmoves/uncompressed/$(iterdirs[1])/otocephala_h3_nosteinphracto.out")]

# the interate over the second element to the end
for i in 2:length(iterdirs)
    #println(i)
    push!(nets, readsnaqnetwork("../h4_outgroup_clean_prop0.1_logmoves/uncompressed/$(iterdirs[i])/otocephala_h3_nosteinphracto.out"))
end

# reroot
map(x -> rootatnode!(x, "Gyrinocheilus_aymonieri_LBPV_114225"), nets)

######## topofreq of bootstrap replicates

bootnets = readmultinewick("../bootsnaq_wo_steinphracto_h4/bootsnaq_wo_steinphracto.tre")

map(x -> rootatnode!(x, "Gyrinocheilus_aymonieri_LBPV_114225"), bootnets)

######## topofreq for major tree on bootnets

majortrees_bootnets = [majortree(x) for x in bootnets]

mudist_majortrees_bootnets = mudist_pairwise(majortrees_bootnets)

@rput mudist_majortrees_bootnets

R"""
library(tbea)
all_majortrees_bootnets <- tbea::topoFreq(dist.matrix = mudist_majortrees_bootnets, output='index')
frel_majortrees_bootnets <- all_majortrees_bootnets$frel
cluster_idx_majortrees_bootnets <- all_majortrees_bootnets$index
"""

@rget frel_majortrees_bootnets

@rget cluster_idx_majortrees_bootnets

length(frel_majortrees_bootnets)

frel_majortrees_bootnets_df = DataFrame(id=1:length(frel_majortrees_bootnets), freq=frel_majortrees_bootnets)

# most frequent major-tree clusters, roughly half of the 200 runs
frel_majortrees_bootnets_df[frel_majortrees_bootnets_df.freq .> 0.1, :]

# clusters of interest
topos_cluster_majtree_idx = cluster_idx_majortrees_bootnets[1]

# do bootsnaq summarisation on that first cluster of 74 topologies :)

mudist_bootnets = mudist_pairwise(bootnets[topos_cluster_majtree_idx])

@rput mudist_bootnets

R"""
all_majortrees_bootnets_retained <- tbea::topoFreq(dist.matrix = mudist_bootnets, output='index')
frel_majortrees_bootnets_retained <- all_majortrees_bootnets_retained$frel
cluster_idx_majortrees_bootnets_retained <- all_majortrees_bootnets_retained$index
"""

@rget frel_majortrees_bootnets_retained

@rget cluster_idx_majortrees_bootnets_retained

# the 6th cluster was the largest, out of 74, comprising nearly 1/2 of the topologies
cluster_idx_majortrees_bootnets_retained

# pick one topo from that group for bootstrapping
bootstrapped_focal_net = bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[6][1]]

# plot one of the major group
PhyloPlots.plot(bootstrapped_focal_net, shownodenumber=true)

PhyloNetworks.rotate!(bootstrapped_focal_net, -7)
PhyloNetworks.rotate!(bootstrapped_focal_net, -22)
PhyloNetworks.rotate!(bootstrapped_focal_net, -23)
PhyloNetworks.rotate!(bootstrapped_focal_net, -17)
PhyloNetworks.rotate!(bootstrapped_focal_net, -19)
PhyloNetworks.rotate!(bootstrapped_focal_net, -20)
 
# summary of tree-like part of the net
## here either pick the complete bootstrap nets or just the subset of major-tree compatible one
boot_table, majortopo = treeedges_support(bootnets, bootstrapped_focal_net);

# summarise hybrid edges
## here either pick the complete bootstrap nets or just the subset of major-tree compatible one
BSn, BSe, BSc, BSgam, BSedgenum = hybridclades_support(bootnets, bootstrapped_focal_net, rooted=true);

show(BSn, allrows=true, allcols=true)
show(BSe, allrows=true, allcols=true) # this is where alternative hybridisations are recovered

tmp = filter(row -> !ismissing(row[:edge]), BSe) # filter rows
select!(tmp, [:edge,:BS_hybrid_edge])            # select 2 columns only
rename!(tmp, :BS_hybrid_edge => :proportion)     # rename those columns, to match names in BSe_tree
rename!(tmp, :edge => :edgeNumber)
tmp = vcat(boot_table, tmp)

# plot the bootstrapped net
R"pdf"("bootstrapped_net_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootstrapped_focal_net, edgelabel=filter(row -> row[:proportion] < 100, tmp), nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]], showgamma=true, xlim=(1,30), tipoffset=0.2);
R"dev.off"()

#### plot the sorted topologies ####

ranked_bootstrap_topo_clusters_idx = collect(1:length(frel_majortrees_bootnets_retained))[frel_majortrees_bootnets_retained .> 0.03]

# plot the seven highest topologies

# plot the bootstrapped net
R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[1])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[1]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[2])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[2]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[3])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[3]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[4])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[4]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[5])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[5]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[6])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[6]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

R"pdf"("../paper_figures/topofreq/bestnet_$(ranked_bootstrap_topo_clusters_idx[7])_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[7]][1]],
                #edgelabel=filter(row -> row[:proportion] < 100, tmp),
                #nodelabel=BSn[:, [:hybridnode,:BS_hybrid_samesisters]],
                showgamma=true,
                xlim=(1,30),
                tipoffset=0.2,
                majorhybridedgecolor="blue",
                minorhybridedgecolor="darkorange3");
R"dev.off"()

# piechart seven topos (supp materials)
piechart_data_seven = frel_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx]

append!(piechart_data_seven, sum(frel_majortrees_bootnets_retained[frel_majortrees_bootnets_retained .< 0.03]))

# the colour pallette is Wong Colourblind Safe Pallette, see https://rgblind.com/blog/color-blindness-friendly-chart-colors 
pie(["4", "6", "7", "9", "12", "17", "25", "other\ntopologies"],
    piechart_data_seven,
    color=["#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"],
    fontfamily="helvetica")

savefig("../paper_figures/topofreq/bestnets_bootnets_h4_topofreq_pie_suppmat.svg")

# piechart four topos (topos 4, 6, 7, 9, first four in ranked_bootstrap_topo_clusters_idx)
piechart_data_four = frel_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[1:4]]

append!(piechart_data_four, sum(frel_majortrees_bootnets_retained[frel_majortrees_bootnets_retained .< 0.05]))

# the colour pallette is one random from here https://rgblind.com/color-blind-palette
pie(["4", "6", "7", "9", "other\ntopologies"],
    piechart_data_four,
    color=["#0685D4", "#27C47A", "#133E3A", "#CA66A7", "#51CFCC"],
    fontfamily="helvetica")

savefig("../paper_figures/topofreq/bestnets_bootnets_h4_topofreq_pie.svg")

# do the major tree of each of the best freq nets differ?

topofreq_majtrees = map(x -> majortree(bootnets[topos_cluster_majtree_idx][cluster_idx_majortrees_bootnets_retained[ranked_bootstrap_topo_clusters_idx[x]][1]]), 1:4)

rfdist_pairwise(topofreq_majtrees, true)

# plot the barplot with bigger font sizes
Plots.scalefontsizes(1.5)

bar(frel_majortrees_bootnets_retained,
    color=:lightgrey,
    legend=false,
    xticks=ranked_bootstrap_topo_clusters_idx,
    fontfamily="helvetica",
    grid=false)

savefig("../paper_figures/topofreq/bestnets_bootnets_h4_topofreq.svg")

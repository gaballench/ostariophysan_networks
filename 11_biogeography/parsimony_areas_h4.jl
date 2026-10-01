using SNaQ
using PhyloNetworks
using PhyloPlots
using DataFrames
using RCall

iterdirs = readdir("../h4_outgroup_clean_prop0.1_logmoves/uncompressed/")

# first network to initialise the vector
nets = [readsnaqnetwork("../h4_outgroup_clean_prop0.1_logmoves/uncompressed/$(iterdirs[1])/otocephala_h3_nosteinphracto.out")]

# the interate over the second element to the end
for i in 2:length(iterdirs)
    push!(nets, readsnaqnetwork("../h4_outgroup_clean_prop0.1_logmoves/uncompressed/$(iterdirs[i])/otocephala_h3_nosteinphracto.out"))
end

# reroot
map(x -> rootatnode!(x, "Gyrinocheilus_aymonieri_LBPV_114225"), nets)

######## topofreq of bootstrap replicates

# without steinphracto
bootnets = readmultinewick("../bootsnaq_wo_steinphracto_h4/bootsnaq_wo_steinphracto.tre")

map(x -> rootatnode!(x, "Gyrinocheilus_aymonieri_LBPV_114225"), bootnets)

######## topofreq for major tree on bootnets

majortrees_bootnets = [majortree(x) for x in bootnets]

topos_majortrees_bootnets, topofreq_majortrees_bootnets, cluster_idx_majortrees_bootnets = topologicalfrequency(majortrees_bootnets, "mu", true, false, true, true)

length(topofreq_majortrees_bootnets)

topofreq_majortrees_bootnets_df = DataFrame(id=1:length(topofreq_majortrees_bootnets), freq=topofreq_majortrees_bootnets)

# most frequent major-tree clusters, roughly half of the 200 runs
topofreq_majortrees_bootnets_df[topofreq_majortrees_bootnets_df.freq .> 10, :]

# clusters of interest
majortree_bootnets_cluster_idx = topofreq_majortrees_bootnets_df[topofreq_majortrees_bootnets_df.freq .> 10, :].id

# do bootsnaq summarisation on that first cluster of 74 topologies :)
topos_cluster_majtree_idx = 1 .== cluster_idx_majortrees_bootnets

topos_majortrees_bootnets_retained, topofreq_majortrees_bootnets_retained, cluster_idx_majortrees_bootnets_retained = topologicalfrequency(bootnets[topos_cluster_majtree_idx], "mu", true, false, true, true)

# the 6th cluster was the largest, out of 74, comprising nearly 1/2 of the topologies
topofreq_majortrees_bootnets_retained

# pick one topo from that group for bootstrapping
bootstrapped_focal_net = topos_majortrees_bootnets_retained[6][1]

# plot one of the major group
PhyloPlots.plot(bootstrapped_focal_net, shownodenumber=true)

PhyloNetworks.rotate!(bootstrapped_focal_net, -7)
PhyloNetworks.rotate!(bootstrapped_focal_net, -22)
PhyloNetworks.rotate!(bootstrapped_focal_net, -23)
PhyloNetworks.rotate!(bootstrapped_focal_net, -17)
PhyloNetworks.rotate!(bootstrapped_focal_net, -19)
PhyloNetworks.rotate!(bootstrapped_focal_net, -20)

###### parsimony ancestral area estimation

 "South America" -> 0
 "Africa (W)" -> 1
 "Asia (SE)" -> 2
 "India" -> 3
 "Asia (NE)" -> 4

areas_num = Dict(
"diplomystes_campoensis19770" => "South America",
"diplomystes_mesembrinus5822" => "South America",
"wagallo_attu_auft5107" => "Asia (SE)",
"kryptoglanis_shajii_ansp3948" => "India",
"ailia_coila_ansp15330" => "India",
"Bagrus_docmak_t18654" => "Africa (W)",
"Amblyceps_foratum_114265" => "Asia (SE)",
"Bagarius_yarrelli_114001" => "Asia (SE)",
"liobagrus_reinii_ansp14901" => "Asia (NE)",
"parakysis_verrucosus_ansp16203" => "Asia (SE)",
"Akysis_patrator_t19004" => "Asia (SE)",
"Cranoglanis_bouderius_114465" => "Asia (SE)",
"phreatobis_spmzsup2461" => "South America",
"goeldiella_eques26619" => "South America",
"conorhynchus_conirostris89907" => "South America",
"conorhyncus_glaber106315" => "South America",
"pseudopimelodus_bufonius27583" => "South America",
"cephalosilurus_apurensis19182" => "South America",
"steindacneridium_parahybae42789" => "South America",
"pimelodus_maculatus61290" => "South America",
"Ageneiosus_dentatus_t10570" => "South America",
"aspredo_aspredo_82139" => "South America",
"chaca_bankanensis_ansp14852" => "Asia (SE)",
"Plotosus_canius_114495" =>"Asia (SE)",
"cetopsis_arcana_64712" => "South America",
"nematogenys_inermis3105" => "South America",
"trichogenes_longipinnis_3862" => "South America",
"sternopygus_macrurus_46840" => "South America",
"citharinus_congicus_818014" => "Africa (W)",
"hepsetus_odoe_257613" => "Africa (W)",
"brycinus_grandisquamis_227411" => "Africa (W)",
"tarumania_walkerae_86548" => "South America",
"hoplias_lacerdae_100386" => "South America",
"Cynodon_gibbus_10227_43105" => "South America",
"serrasalmus_maculatus_22107" => "South America",
"saccodon_dariensis_90710" => "South America",
"paradon_nasus104593" => "South America",
"anostomus_anostomus_USNM402905" => "South America",
"chalceus_epakros_63835" => "South America",
"boulengerella_cuvieri61652" => "South America",
"poecilocharax_bovallii_69030" => "South America",
"characidium_etheostoma_86571" => "South America",
"Gyrinocheilus_aymonieri_LBPV_114225" => "Asia (SE)")

areas_num = Dict(
"diplomystes_campoensis19770" => 0,
"diplomystes_mesembrinus5822" => 0,
"wagallo_attu_auft5107" => 2,
"kryptoglanis_shajii_ansp3948" => 3,
"ailia_coila_ansp15330" => 3,
"Bagrus_docmak_t18654" => 1,
"Amblyceps_foratum_114265" => 2,
"Bagarius_yarrelli_114001" => 2,
"liobagrus_reinii_ansp14901" => 4,
"parakysis_verrucosus_ansp16203" => 2,
"Akysis_patrator_t19004" => 2,
"Cranoglanis_bouderius_114465" => 2,
"phreatobis_spmzsup2461" => 0,
"goeldiella_eques26619" => 0,
"conorhynchus_conirostris89907" => 0,
"conorhyncus_glaber106315" => 0,
"pseudopimelodus_bufonius27583" => 0,
"cephalosilurus_apurensis19182" => 0,
"steindacneridium_parahybae42789" => 0,
"pimelodus_maculatus61290" => 0,
"Ageneiosus_dentatus_t10570" => 0,
"aspredo_aspredo_82139" => 0,
"chaca_bankanensis_ansp14852" => 2,
"Plotosus_canius_114495" =>2,
"cetopsis_arcana_64712" => 0,
"nematogenys_inermis3105" => 0,
"trichogenes_longipinnis_3862" => 0,
"sternopygus_macrurus_46840" => 0,
"citharinus_congicus_818014" => 1,
"hepsetus_odoe_257613" => 1,
"brycinus_grandisquamis_227411" => 1,
"tarumania_walkerae_86548" => 0,
"hoplias_lacerdae_100386" => 0,
"Cynodon_gibbus_10227_43105" => 0,
"serrasalmus_maculatus_22107" => 0,
"saccodon_dariensis_90710" => 0,
"paradon_nasus104593" => 0,
"anostomus_anostomus_USNM402905" => 0,
"chalceus_epakros_63835" => 0,
"boulengerella_cuvieri61652" => 0,
"poecilocharax_bovallii_69030" => 0,
"characidium_etheostoma_86571" => 0,
"Gyrinocheilus_aymonieri_LBPV_114225" => 2)

parsimony_area = PhyloNetworks.parsimonyfitch(bootstrapped_focal_net, areas_num)

parsimony_area[2]

nodelabel_df = DataFrame(node=collect(keys(parsimony_area[2])), label=map(x->map(*,collect(x)),values(parsimony_area[2])))

plot(bootstrapped_focal_net, nodelabel=nodelabel_df ,shownodelabel=true)

# plot the parsimony area reconstruction
R"pdf"("parsimony_area_reconstruction_h4.pdf", width=12, height=12)
PhyloPlots.plot(bootstrapped_focal_net, nodelabel=nodelabel_df ,shownodelabel=true, xlim=(1,30), tipoffset=0.2);
R"dev.off"()


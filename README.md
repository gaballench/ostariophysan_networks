# ostariophysan_networks

Code and results for the article "Beyond tree-like evolution in Ostariophysan fishes" by Ballen et al. (2026)

## Dependencies

This project uses a number of programs whose installation depends more or less on the type of cumputing equipment used. I have tried to use conda environments as much as possible but sometimes, for instance on the Open Science Grid, it's simply easier to use singularity containers. Given the timespan of the project, it is impossible to provide exact version numbers except for specific cases where new code was contributed, and therefore need to be such versions or higher. The software is listed under each of the respective steps.

## A note on reproducibility

It is often desirable that a project repository allows to reproduce completely a given workflow. Here however I attempt at providing documented code but not necessarily to make it reproducible. The reason is purely practical: This project used three kinds of computing engines: A laptop with graphical device, a server with 124 threads, and the Open Science Grid. Each step was carried out in a given equipment that best suited the performance needs. Unless someone has access to these three equipments, the workflow cannot be reproduced. Importantly, even havin a cluster available does not resolve the reproducibility issue. I hope to make it possible for someone to adapt the workflow for their equipment at hand by providing the scripts. My goal here was to provide details to document the workflow instead.

## Repository structure

Each directory numbered from 00 onwards contains the code for each sequential step in the data analysis. Each step is described along with the type of computing equipment necessary, be it laptop (`LPT`), server (`SRV`), or the Open Science Grid (`OSG`)

## Steps

### 00\_align

(`SRV`) Multiple sequence alignment was carried out using MAFFT sequentially on each uce fasta file, allowing it to use 20 threads.

### 01\_gene\_trees

(`SRV`) Maximum likelihood gene tree estimates were inferred using IQTREE3 with 40 threads, with a directory containing the aligned fasta files for the uces returned in the previous step. Nucleotide model selection was automatic, so that each of the gene trees was estimated on its own best model.

### 02\_species\_tree

(`SRV`) A species tree was estimated using the gene tree MLEs as input using TREE-QMC under the multispecies coalescent. One of the outgroups, *Lepisosteus*, was removed so that the root was represented by a single branch, *Amia*. Rerooting of gene tree MLEs and the resulting species tree was carried out using phyx. These were all single thread operations.

### 03\_tree\_of\_blobs

(`SRV`) The tree of blobs was estimated using the species tree in the previous step as well as the gene tree MLEs, again using TREE-QMC. This is also a single-thread operation. This took 4726 seconds (approximately 1.3 hours).

### 04\_gene\_tree\_bootstrap

(`OSG`) This operation could be carried out in parallel for each gene tree in an efficient way using the `OSG`, allowing each process to use a maximum of 10 threads. Bootstrap method was the ultrafast one of IQTREE3, preserving the bootstrapped gene tree topologies. IQTREE3 was containerised using singularity.

### 05\_subset\_for\_snaq

(`LPT`) From the tree of blobs in step 03, several branches were identified as statistically rejecting both tree-likeness and star-treeness, and therefore are candidates for reticulate evolution. Although SNaQ is now better than ever in efficiency in handling larger datasets, it is still far from allowing inference of phylogenetic networks for 231 taxa. Therefore, a pruned version of the problem was subsampled to just 43 taxa aiming at preserving regions of the topology where reticulations may be present but still allowing SNaQ to handle the dataset. This is the largest network attempted at with SNaQ to our knowledge, doubling the soft maximum of around 20 that is commonly used in empirical studies. Then, a species tree was again estimated using TREE-QMC to serve as initial tree in later runs of SNaQ. This species tree was rooted at *Gyrinocheilus*. Tree manipulation was carried out using phyx.

### 06\_CF\_and\_CIs

(`SRV`) The ultrafast files generated in step 04 were used along with the gene tree MLEs to construct a quartet concordance factor (qCF) table which also calculates 95\% confidence intervals for these qCFs. This was done using SNaQ >=v1.2.0 in Julia.

### 07\_network\_inference

(`OSG`) SNaQ was called sequentially using the qCF table from the previous step in all cases. For h=0, the initial species tree estimated in step 05 was used as starting topology. For h=1 onwards, the best topology in the previous step was used as initial topology, going from h=1 to h=7. A number of 200 independent runs were launched in parallel, each using 10 threads. Network estimation was carried out using SNaQ in Julia.

### 08\_bestnetworks\_h0\_h7

(`LPT`) The resulting networks for each iteration of SNaQ were collected and plotted so that the heuristic of gradient stabilisation was used. This allowed to choose h=4 as the best network, which implies that a tree (i.e., h=0) is not the best topology for the dataset, suggesting a network instead. This directory contains these topologies. Code for fetching the composite likelihood values and plotting them agains the number of reticulations is available in the `bestnet_heuristics` subdirectory.

### 09\_network\_bootstrap

(`OSG`) Bootstrapping was carried out using the topology with h=4 as the initial one, sampling qCF values from their 95\% confidence intervals. A total of 1000 independent runs were launched in parallel, also using 10 threads per run. Bootstrapping was carried out with SNaQ in julia.

### 10\_summaries\_and\_plots

(`LPT`) Uncertainty assessment both for edges (especially hybrid edges) and topologies was carried out with PhyloNetworks in Julia and tbea v1.8.0 in R, calling R code from Julia with the RCall package. Plotting was carried out with the PhyloPlots package also in Julia. This approach uses the bootstrapped topologies in step 09 and is single-threaded.

### 11\_biogeography

(`LPT`) Biogeographic analysis under parsimony was carried out on the chosen topology with h=4 using PhyloNetworks and plotting with PhyloPlots, both in Julia.

## Citation

Please cite the article:

Ballen, G.A., Solís-Lemus, C. Tiley, G.P. \& Oliveira, C. 2026. Beyond tree-like evolution in Ostariophysan fishes.

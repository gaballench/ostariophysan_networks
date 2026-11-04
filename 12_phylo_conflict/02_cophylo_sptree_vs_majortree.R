library(ape)
library(phytools)

# read astral sptree
sptree <- read.tree("../results/otocephala_wo_steinphracto_sptree_rotated_to_majortree.astral")

# read the major tree for h4
mjtree <- read.tree("../../snaq_46taxa/wo_steinphracto_h4_majortree/otocephala_wo_steinphracto_h4_majortree.tre")

mjtree <- root(mjtree, "Gyrinocheilus_aymonieri_LBPV_114225")

# cotangleplot
pdf("../results/otocephala_sptree_vs_mjtreeh4_cotangleplot.pdf", width=20, height=10)
cotangleplot(sptree, mjtree, "cladogram", FALSE, "both")
dev.off()

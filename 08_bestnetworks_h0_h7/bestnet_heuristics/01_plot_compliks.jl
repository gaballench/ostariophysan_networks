using CSV
using DataFrames
using StatsPlots

# load data w/o steinphracto
compliks_wo_steinphracto = CSV.read("../results/bestnets_logliks_wo_steinphracto", DataFrame)

# make larger plot font sizes
Plots.scalefontsizes(1.5)

# plot for w/o steinphracto
@df compliks_wo_steinphracto plot(:complik,
                                  fontfamily="helvetica",
                                  grid=false,
                                  color=:purple,
                                  xlabel="Max. num. hybrid edges",
                                  ylabel="Neg. comp. likelihood",
                                  linewidth=3,
                                  xticks=(1:8, :net),
                                  legend=false)
@df compliks_wo_steinphracto scatter!(:complik, color=:purple)

annotate!(5, 290, "▼")

savefig("../results/compliks_wo_steinphracto.svg")

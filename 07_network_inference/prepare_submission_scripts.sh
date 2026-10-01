#!/usr/bin/env bash

# this is just the first script we should call before submitting with condor_submit
# just fill in below the information and run it once.

# it will do replacements in the snaq.sh and snaq.sub scripts where identical fields are used
# all these files must be in the OSG path
# cftablefield is the name of the cf table csv file
# treefield is the name of the initial tree file
# versionfield is a number X indicating the version of the script estimation_snaq_vX.jl
# osdflocationfield e.g. "otocephala_subsampled_snaq" in the otocephala analysis
# outnamefield is the output prefix for both the out and log files 
# outgroupfield is the taxon to use as outgroup
# hfield which hmax to run
# numreplicates how many OSG instances to submit

CFTABLEFIELD="CFs_otocephala_subsampled_taxa_steindach_phracto.csv"
TREEFIELD="otocephala_bestnet_h6_nosteinphracto_outgroup_clean_prop0.1_logmoves.tre"
VERSIONFIELD="4"
OSDFLOCATIONFIELD="otocephala_subsampled_snaq"
OUTNAMEFIELD="otocephala_h7_nosteinphracto"
OUTGROUPFIELD="Gyrinocheilus_aymonieri_LBPV_114225"
NUMREPLICATESFIELD=200
HFIELD=7

### here starts the code proper

# create the final files
touch snaq.sh
cat _template_snaq.sh > snaq.sh
touch snaq.sub
cat _template_snaq.sub > snaq.sub

#replacement for cftablefield
sed -i "s/cftablefield/$CFTABLEFIELD/g" snaq.sh
sed -i "s/cftablefield/$CFTABLEFIELD/g" snaq.sub

# replacement for treefield
sed -i "s/treefield/$TREEFIELD/g" snaq.sh
sed -i "s/treefield/$TREEFIELD/g" snaq.sub

# replacement for versionfield
sed -i "s/versionfield/$VERSIONFIELD/g" snaq.sh
sed -i "s/versionfield/$VERSIONFIELD/g" snaq.sub

# replacement for osdflocationfield
sed -i "s/osdflocationfield/$OSDFLOCATIONFIELD/g" snaq.sub

# replacement for outnamefield
sed -i "s/outnamefield/$OUTNAMEFIELD/g" snaq.sh

# replacement for outnamefield
sed -i "s/outgroupfield/$OUTGROUPFIELD/g" snaq.sh

# replacement for outnamefield
sed -i "s/numreplicatesfield/$NUMREPLICATESFIELD/g" snaq.sub

# replacement for outnamefield
sed -i "s/hfield/$HFIELD/g" snaq.sh

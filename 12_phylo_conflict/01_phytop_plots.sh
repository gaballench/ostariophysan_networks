#!/usr/bin/env bash

# activate the conda env with phytop, which also contains phyx

# set the dir structure
cd ../results
mkdir phytop_results
cd phytop_results

phytop ../otocephala_wo_steinphracto_sptree_rotated_to_majortree.astral

mkdir mkdir piecharts
cd piecharts

phytop ../../otocephala_wo_steinphracto_sptree_rotated_to_majortree.astral -pie -cp

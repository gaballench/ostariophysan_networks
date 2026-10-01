#!/usr/bin/env bash

# redirecting to a file for later sorting with R or something
# header and create the file
echo "filename,negploglik" > logliks.csv 
# append the data to it
zgrep -ao "\-Ploglik=[0-9.-]*" *tar.gz | sed 's/-Ploglik=//' | sed 's/:/,/' >> logliks.csv

Rscript loglik_ordering.R

#!/usr/bin/env bash

echo "net,complik" > ../results/bestnets_logliks_wo_steinphracto

for i in $(seq 0 7); do
    COMPLIK=$(grep -o "Ploglik.*" ../wo_steindachnerina_phractocephalus/bestnets/*h$i*)
    echo "h"$i","$COMPLIK >> ../results/bestnets_logliks_wo_steinphracto
done

# cleanup the captured complik data
sed -i 's/Ploglik = //g' ../results/bestnets_*

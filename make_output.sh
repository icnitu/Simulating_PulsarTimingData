#!/bin/bash

. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J1022+1001;
N=10


sim=W1S1R0D1;

for i in $(seq 1 $((N)))
do
    echo "!!! "${i};
    sed -i '$d' ${psr}_${sim}_v${i}_post_wfit.par;
    sed -i '/^$/d' ${psr}_${sim}_v${i}_post_wfit.par;

    echo "TNsubtractDM 1" >> ${psr}_${sim}_v${i}_post_wfit.par;

    rm output_${sim}_v${i}_${psr}sim.dat;
    echo "# {sat} {spherical_sw} {spherical_sw_dm}[freq-indep] {solarangle} {posttn} {err}[us] {freq}" >> output_${sim}_v${i}_${psr}sim.dat;
    tempo2 -output general2 -f ${psr}_${sim}_v${i}_post_wfit.par ${sim}_v${i}_${psr}sim.tim -s '{sat} {spherical_sw} {spherical_sw_dm} {solarangle} {posttn} {err} {freq} zzz\n' | grep 'zzz' >> output_${sim}_v${i}_${psr}sim.dat;

done


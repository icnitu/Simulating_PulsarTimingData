#!/bin/bash

. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J1022+1001
mjdfile=peak_MJDs.txt
par=${psr}_0.par

# awk '/^_NE_SW/ {print $2}' ${psr}_${sim}_v${i}_post_wfit.par > peak_MJDs.txt
# cp ${psr}.par ${psr}_0.par;

tempo2 -gr fake -f ${par} -times ${mjdfile} -rms 0.001 -nofit;

tempo2 -output general2 -f ${par} ${psr}_0.simulate -s '{sat} {spherical_sw} {spherical_sw_dm} {solarangle} zzz\n' | grep 'zzz' >> sphericalSW_peaks_${psr}.txt;

#!/bin/bash

. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J1022+1001
par=${psr}_LOFAR.par
tim=ideal_${psr}sim.tim

rm sphericalSW_${psr}.txt;

tempo2 -output general2 -f ${par} ${tim} -s '{sat} {spherical_sw} {spherical_sw_dm} {solarangle} zzz\n' | grep 'zzz' >> sphericalSW_${psr}.txt; 

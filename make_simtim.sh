#!/bin/bash

. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J1022+1001
par=${psr}_LOFAR.par
idealtim=ideal_${psr}sim.tim
# These numbers come from the EPTA WM2 paper draft:
Pyr3=8.4e-31
aRN=-3.4
TNDMAmp=-11.4
aDM=-0.4
SWsample=DMvar_samples_${psr}


: '
# add TNEF and TNEQ to ${psr}_forideal.par

tempo2 -gr formIdeal -f ${psr}_forideal.par ${psr}sim.tim;

mv ${psr}sim.tim.sim ideal_${psr}sim.tim;

'

N=10
seed=-29

#echo "\nWHITE NOISE:\n"

tempo2 -gr addGaussian -f $par $idealtim -nreal $N -seed ${seed};

#echo "\nRED NOISE:\n"

tempo2 -gr addRedNoise -f $par $idealtim -Pyr3 $Pyr3 -a $aRN -nreal $N -seed ${seed};
# equivalent to TNRedAmp = -14

#echo "\nDM NOISE:\n"

tempo2 -gr addDmVar -f $par $idealtim -TNDMAmp $TNDMAmp -a $aDM -nreal $N -seed ${seed};

#echo "\nSOLAR WIND:\n"

tempo2 -gr addArbitraryDM -f $par $idealtim -dm $SWsample -nreal $N -seed ${seed};


for i in $(seq 0 $((N-1)))
do
    #echo $i
    echo $((i+1))

    tempo2 -gr createRealisation -f $idealtim -corn ${idealtim}.addGauss $i -corn ${idealtim}.addArbitraryDM $i -corn ${idealtim}.addRedNoise $i -corn ${idealtim}.addDmVar $i;
    mv ${idealtim}.real W1S1R1D1_v${i}_${psr}sim.tim;
done


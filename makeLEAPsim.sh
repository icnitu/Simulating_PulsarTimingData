#!/bin/bash

. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J1022+1001
par=$psr.par
ogsim=${psr}_LEAP.simulate

rm $ogsim;

tempo2 -gr fake -f $par -ndobs 30 -nobsd 1 -randha y -start 60050 -end 63703 -rms 0.00025 -tel leap;
mv ${psr}.simulate ${ogsim};

sed -i 's/$/-sys LEAP -group LEAP/g' ${ogsim};

mv ${ogsim} ${psr}_LEAPsim.tim;

#tempo2 -gr formIdeal -f $par ${psr}_LEAPsim.tim;
#mv ${psr}_LEAPsim.tim.sim ideal_${psr}_LEAPsim.tim;




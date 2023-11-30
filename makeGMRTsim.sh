#!/bin/bash

. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J1022+1001
par=$psr.par
ogsim=${psr}_GMRT.simulate

rm $ogsim;

tempo2 -gr fake -f $par -ndobs 12 -nobsd 1 -randha y -start 60000 -end 63653 -rms 0.001 -tel gmrt;
mv ${psr}.simulate ${ogsim};

B3freqs=(302.34375 308.59375 314.84375 321.09375 327.34375 333.59375 339.84375 346.09375 352.34375 358.59375 364.84375 371.09375 377.34375 383.59375 389.84375 396.09375 402.34375 408.59375 414.84375 421.09375 427.34375 433.59375 439.84375 446.09375 452.34375 458.59375 464.84375 471.09375 477.34375 483.59375 489.84375 496.09375);
B5freqs=(1285.097656 1335.097656 1385.097656 1435.097656);

B3medrms=7;
B5medrms=20;

B3sys=GMRT_B3; 
B5sys=GMRT_B5;

B3group=GMRT_B3; 
B5group=GMRT_B5;

rm ${ogsim}.B5;
sed 's/$/-sys '${B5sys}' -group '${B5group}'/g' $ogsim >> ${ogsim}.B5;
sed -i 's/ 1.00000 / 20.00000 /g' ${ogsim}.B5;

rm ${ogsim}.B3;
sed 's/$/-sys '${B3sys}' -group '${B3group}'/g' $ogsim >> ${ogsim}.B3;
sed -i 's/ 1.00000 /  7.00000 /g' ${ogsim}.B3;

rm ${ogsim}.B5.*;

for f in ${B5freqs[@]};
do
    sed 's/1440.00000000/'${f}'/g' ${ogsim}.B5 >> ${ogsim}.B5.${f};
done

rm ${ogsim}.B3.*;

for f in ${B3freqs[@]};
do
    sed 's/1440.00000000/  '${f}'/g' ${ogsim}.B3 >> ${ogsim}.B3.${f};
done

rm ${psr}sim.tim;
cat ${ogsim}.*.* | sort -nk3 >> ${psr}_GMRTsim.tim;

#tempo2 -gr formIdeal -f $par ${psr}_GMRTsim.tim;
#mv ${psr}_GMRTsim.tim.sim ideal_${psr}_GMRTsim.tim;




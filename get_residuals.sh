. /packages/pulsarsoft/next_version/login/psr.bashrc;

psr=J0034-0534
par=${psr}.par

N=9
sim="W1S1R1D1"

for i in $(seq 13 14)
do

    for s in 1 0
    do
        echo "***** v"${i}"_fitS1 *****"

        tempo2 -f ${psr}_${sim}_v${i}_fitS${s}.par.post ${sim}_v${i}_${psr}sim.tim -newpar;
        
        mv new.par ${psr}_${sim}_v${i}_fitS${s}_post_wfit.par;

        sed -i '$d' ${psr}_${sim}_v${i}_fitS${s}_post_wfit.par;
        sed -i '/^$/d' ${psr}_${sim}_v${i}_fitS${s}_post_wfit.par;
    
        rm ${psr}_${sim}_v${i}_fitS${s}_post_wfit_TNsubtractRed.par;
        cp ${psr}_${sim}_v${i}_fitS${s}_post_wfit.par ${psr}_${sim}_v${i}_fitS${s}_post_wfit_TNsubtractRed.par    

        echo "TNsubtractRed 1" >> ${psr}_${sim}_v${i}_fitS${s}_post_wfit_TNsubtractRed.par;

        tempo2 -output general2 -f ${psr}_${sim}_v${i}_fitS${s}_post_wfit_TNsubtractRed.par ${sim}_v${i}_${psr}sim.tim -s '{sat} {posttn} {err} {freq} zzz\n' | grep 'zzz' >> residuals_v${i}_post_fitS${s}.txt;

    done

done


#!/bin/bash


psr=J0751+1807
par=${psr}.par
idealtim=ideal_${psr}sim.tim
# idealtim is whatever tim file you want to add your simulations to;
# I use idealised tim files, which I get with something like
# tempo2 -gr formIdeal -f ${par} ${psr}.tim

# Here I just define the parameters used to simulate, for example:
# for a power law DM variation 
# these should be the temponest-type amplitude and slope
# as is fit by e.g. the run_enterprise code
TNDMAmp=-12.5
aDM=-2.67 # note this needs to be negative

# or, we could add a specific DM variation 
# by writing a file with two columns: MJD and DM value
# -- this is what I use to add Solar wind, for example
DMseries=DMvar_samples_${psr}
# !! also note that this looks for files ${DMseries}.0, and then .1, .2 etc
# depending on how many realisations you have (i.e. different DM series you want to use);
# but the main thing here is that if you have a single DM series you want to use
# the file has to be named ${DMseries}.0


# you can simulated multiple 'realisations' at the same time
# here I do 10
N=10
# you can also use a seed to have reproducible results
seed=-29

# first, I add some gaussian (white) noise
tempo2 -gr addGaussian -f $par $idealtim -nreal $N -seed $seed;
# -> this should give you a file called ${idealtim}.addGauss

# this is how I add the power-law DM:
tempo2 -gr addDmVar -f $par $idealtim -TNDMAmp $TNDMAmp -a $aDM -nreal $N -seed $seed;
# -> this should give you a file called ${idealtim}.addDmVar

# and this is how to add the specific DM series
tempo2 -gr addArbitraryDM -f $par $idealtim -dm $DMseries -nreal $N -seed $seed;
# -> this should give you a file called ${idealtim}.addArbitraryDM

# So the .add* files have the actual realisations of the specific types
# Now to actually add them and get .tim files (a different one for each realisation):

for i in $(seq 0 $((N-1)))
# note that the realisations are counted from 0
# but I like counting from 1, soo that's why there's this (i+1) everywhere
do

    echo $((i+1))

    # here I add all of the things at the same time
    # but you can add just some of them
    tempo2 -gr createRealisation -f $idealtim -corn ${idealtim}.addGauss $i -corn ${idealtim}.addArbitraryDM $i -corn ${idealtim}.addDmVar $i;
    # then I just move the standard named file 
    # otherwise they will get over-written by the next one
    mv ${idealtim}.real ${psr}sim_v$((i+1)).tim;
done

# TA-DA! you now have tim files with simulated DM


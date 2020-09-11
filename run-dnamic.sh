echo "Beginning simulation."
# remove old sampledir, if it exists
rm -rf sampledir/

# renew it and copy your desired file of 3D positions
cp -R empty-sampledir/ sampledir/
cp posfile.csv sampledir/posfile.csv

# run simulation code [warning: this can take a _long_ time, 20-30 mins]
cd sampledir/
python2 ../simOps.py  # run chemical 'dynamics' simulation
python2 ../main.py  # simulate noisy DNA sequencing
python2 ../main.py msmle_infer  # use modified spectral-MLE to infer positions
python2 ../main.py ptmle_infer  # use point-MLE to infer positions

# save the relevant position files to base directory
SMLE_SRC=$(find . -regex ".*r[0-9]*/infer_msmle/final_Xumi.*.csv" | tail -1)
SMLE_DST=../infer_smle_final_Xumi.csv
cp $SMLE_SRC $SMLE_DST

PTMLE_SRC=$(find . -regex ".*r[0-9]*/infer_ptmle/final_Xumi.*.csv" | tail -1)
PTMLE_DST=../infer_ptmle_final_Xumi.csv
cp $PTMLE_SRC $PTMLE_DST

# send updated runname
echo "This was experiment 11 w/ SOL assoc100x rmax 0.6, numi 0.5k+2.0k, defaults on Weinstein's optimOps with perplexity rownorm=True" > ./exp-info.txt

# process metrics
# cd ..
# python3 metrics.py

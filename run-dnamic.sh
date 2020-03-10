# remove old sampledir, if it exists
rm -rf sampledir/

# renew it and copy your desired file of 3D positions
cp -R empty-sampledir/ sampledir/
cp posfile.csv sampledir/posfile.csv

# run simulation code [warning: this can take a _long_ time, 20-30 mins]
cd sampledir/
python2 ../simOps.py
python2 ../main.py
python2 ../main.py smle_infer
python2 ../main.py ptmle_infer

# save the relevant position files to base directory
SMLE_SRC=$(find . -regex ".*r[0-9]*/infer_smle/final_Xumi.*.csv" | tail -1)
SMLE_DST=../infer_smle_final_Xumi.csv
cp $SMLE_SRC $SMLE_DST

PTMLE_SRC=$(find . -regex ".*r[0-9]*/infer_ptmle/final_Xumi.*.csv" | tail -1)
PTMLE_DST=../infer_ptmle_final_Xumi.csv
cp $PTMLE_SRC $PTMLE_DST

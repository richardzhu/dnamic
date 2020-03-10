# dnamic

Developed within the Weinstein Lab at the University of Chicago.

## Summary

DNA microscopy is a new technology development program to achieve spatio-genetic imaging without the use of specialized machinery.

## Guide to use

### Installation

* Use `pyenv` or `virtualenv` to establish `python=2.7.15+`. (I know, we'll be upgrading this to Python 3 ASAP).
* Use pip to install requirements, e.g. `python2 -m pip install -r requirements.txt`.

### Generating positions

Save a 3D file of positions to `./posfile.csv` with the following columns (no
header row):
1. Point index
2. Boolean index, 0 for beacon and 1 for target. (Recommend randomly dividing 
half your points into beacons and targets)
3. X position
4. Y position
5. Z position

### Running simulation & inference code

Execute script `./run_dnamic.sh`, which will copy the position file to the proper
directory, run simulation/inference code (can take up to 20-30 minutes depending 
on your hardware), and copy the final inferred positions back to the root directory.

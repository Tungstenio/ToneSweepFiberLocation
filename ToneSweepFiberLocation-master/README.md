# ToneSweepFiberLocation
Contains MATLAB files and data series necessary for running the method described in the article "A Low-Frequency Tone Sweep Method for Fault Location in Optical Fiber Links"

The software was designed and works in MATLAB 2015.

## Submodules:

1. FreqToneFaultLocation_Main.m
    Is the main file containing the data read and call to main routine

2. CalculaSinc.m
    Auxiliary function to compute the value os a "sinc" function in a given position, for some given set of parameters.

3. coef2delta.m
    Converts coeficients obtained from the fitting algorithm into loss values.

4. extensiveSearch.m
    Contains the core subroutine that performs extensive search in the feasible space.


## Input data:

The following files must exist and be located in the same folder as the routines.
See the existing ones for reference.

1. CallibratedData.csv
    Is a CSV file, with N lines (one for each measurement) and with 5 columns
    1. Frequency; 
    2. Real part of new measurements
    3. Imaginary part of new measurements
    
2. signature.csv
    Is a CSV file, with K lines (one for each known fault) and 2 columns for a event list
    Column 1 represents positions of the fault
    Column 2 represents aplitude of the fault
    Each line represents a fault event

3. Parameters.csv
   Is a CSV file, with 5 lines and 1 column
    1. Fiber End
    2. ng
    3. $\alpha$ (in db/km)
    4. Known loss aplitude [optional , just set 0 if you dont know]
    5. Known loss position [optional , just set 0 if you dont know]


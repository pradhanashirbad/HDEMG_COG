# HDEMG FEATURE EXTRACTION

The HDEMG tool can be used for extracting spatial information from HDEMG grids. 

## Description

The tool reads data from one or more simultaneous EMG recordings from grids. The grids can have the following dimensions: 
1) 8x4 (32)
2) 8x8 (64)
3) 13x5 (64)

Spatial features are extracted such as: 1) entropy 2) intensity 3) differential intensity 4) Coefficient of Variation 5) X and Y coordinates of centre of gravity 6) mean value

## Getting Started

### Dependencies

* Matlab R2020a or higher
* Matlab Statistics and Machine Learning toolbox, Matlab signal processing toolbox

### Executing program

1. config.m: Update the sampling frequency of the recording. For convenience update the data path in config.m
2. The tool doesnt need installation, run HDEMGMainProg.m. 
3. Select the layout of data (for e.g., 32x1, 32x2, 64x1 (square), 64x1 (rectangular), 64x2 grids)
3. Load the data file (.csv or .mat) Valid data files have columns in the multiples of 32 (x32), where the number of rows are the samples. Additionally there can be an extra column (Column 0) for time and Column (D+1) for the auxillary data (Force,Torque etc.)
4. Select the signal processing configurations: 1) Bandpass Filtering (20 Hz - 450 Hz), 2) Monopolar to Bipolar conversion (along the longer axis) 3) Data normalization (normalization can be to the maximum value of a trial or to the maximum value of an MVC trial
5. Load the HDEMG analysis layout
6. Default Feature used to build the HD Maps is using the RMS feature
7. Change feature selection to Median Frequency (MDF) and Average Rectified Value (ARV)
8. Change feature extraction window size (125 ms, 250 ms or 500 ms)
9. Select the timepoint using the cursor button and click on the Aux curve.
10. Select output filenames and click export results.

## Images
<img src="https://github.com/pradhanashirbad/HDEMG_COG/blob/main/images/HDEMG1.JPG" width="70%" >

## Help

In case of errors while closing the HDEMG windows, make sure to change path to the original folder containing the code files.

## Authors

Contributors names and contact info

ex. [@Ashirbad Pradhan](https://pradhanashirbad.github.io)

## Version History

* 0.4
    * Various bug fixes and optimizations
    * * See [commit change]() or See [release history]()
* 0.3
    * Added changing epoch size in miliseconds
    * Various bug fixes and optimizations: graphing issues, reduce the processing points by ten for faster performance 
* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under GPLv2 [https://www.gnu.org/licenses/gpl-2.0.html]

## Acknowledgments


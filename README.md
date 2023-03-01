# HDEMG FEATURE EXTRACTION

The HDEMG tool can be used for extracting spatial information from HDEMG grids. The work has been described  in our previous works. Please cite: 
1) [Pradhan, A., Malagon, G., Lagacy, R., Chester, V., & Kuruganti, U. (2020). Effect of age and sex on strength and spatial electromyography during knee extension. Journal of physiological anthropology, 39(1), 1-11](https://jphysiolanthropol.biomedcentral.com/articles/10.1186/s40101-020-00219-9)
2) [Kuruganti, U., Pradhan, A., & Toner, J. (2021). High-Density Electromyography Provides Improved Understanding of Muscle Function for Those with Amputation. Frontiers in Medical Technology, 3, 690285.](https://www.frontiersin.org/articles/10.3389/fmedt.2021.690285/full)

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

1. config.m: Update the sampling frequency of the recording, grid layout for analysis. For convenience update the data path in config.m
2. The tool doesnt need installation, run HDEMGMainProg.m. 
3. Select the layout of data (for e.g., 32x1, 32x2, 64x1 (square), 64x1 (rectangular), 64x2 grids)
3. Load the data file (.csv or .mat) Valid data files have columns in the multiples of 32 (x32), where the number of rows are the samples. Additionally there can be an extra column (Column 0) for time and Column (D+1) for the auxillary data (Force,Torque etc.)
4. Select the signal processing configurations: 1) Bandpass Filtering (20 Hz - 450 Hz), 2) Monopolar to Bipolar conversion (along the longer axis) 3) Data normalization (normalization can be to the maximum value of a trial or to the maximum value of an MVC trial or no normalization
5. In case of agonist and antagonist muscle activity, check on the CCI metric and select the two equal sized grids for CCI analysis
5. Load the HDEMG analysis layout
6. Default Feature used to build the HD Maps is using the RMS feature
7. Change feature selection to Median Frequency (MDF) and Average Rectified Value (ARV)
8. Change feature extraction window size (125 ms, 250 ms or 500 ms)
9. Select the timepoint using the cursor button and click on the Aux curve
10. Select output filenames and click export results

## Images
<img src="https://github.com/pradhanashirbad/HDEMG_COG/blob/main/images/HDEMG1.JPG" width="70%" >

## Help

In case of errors while closing the HDEMG windows, make sure to change path to the original folder containing the code files.

## Authors

Contributors names and contact info

[@Ashirbad Pradhan](https://pradhanashirbad.github.io)
[@Usha Kuruganti](https://www.unb.ca/faculty-staff/directory/kinesiology/kuruganti-usha.html)

## Version History
* 0.6
    * Various bug fixes and optimizations
    * * See [commit change](https://github.com/pradhanashirbad/HDEMG_COG/commit/54c419b0524ae9114a93402fe1b49e168bc97ba9s) 
* 0.5
    * Various bug fixes and optimizations
    * * See [commit change](https://github.com/pradhanashirbad/HDEMG_COG/commit/5b6d3ae0c5f3e3849a934b0f2fc3c82f31823297) 
* 0.4
    * Various bug fixes and optimizations
    * * See [commit change](https://github.com/pradhanashirbad/HDEMG_COG/commit/a12af50306b28aace6adb2a8f14a4605d2776789) 
* 0.3
    * Added changing epoch size in miliseconds
    * Various bug fixes and optimizations: graphing issues, reduce the processing points by ten for faster performance 
* 0.2
    * Various bug fixes and optimizations
    * See [commit change]()
* 0.1
    * Initial Release

## License

This project is licensed under GPLv2 [https://www.gnu.org/licenses/gpl-2.0.html]

## Acknowledgments


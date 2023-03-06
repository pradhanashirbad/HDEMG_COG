% CONFIG
% set configuration.
%
% Author: Ashirbad Pradhan, 2023.
%

%% Path to the data file
SETTINGS_PATH = pwd;

%% Path to the data file
DATA_PATH = pwd;

%% Grid Configuration
% Follow the convention of grid layout: 32 , 64. For example, three
% grids of 32,32 and 64 should be shown as GRID_CONFIG = [32,32,64]. One grid of 64
% should be shown as GRID_CONFIG = [64];
GRID_CONFIG = [64];

%% Sampling frequency
F_SAMP = 2000;

%% Processing window size in ms
% valid entries are 125, 250, 500 and 1000. Any other will not execute
WINDOW_SIZE_MS = 250; 


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
% Follow the convention of grid layout: 1--32 , 2--64. For example, three
% grids of 32,32 and 64 should be shown as IS_32 = [1,1,2]. One grid of 64
% should be shown as GRID_CONFIG = [2];
GRID_CONFIG = [1,1];

%% Sampling frequency
F_SAMP = 2000;

%% Processing window size in ms
% valid entries are 125, 250, 500 and 1000. Any other will not execute
WINDOW_SIZE_MS = 250; 


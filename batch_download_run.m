% This script will download the dataset from the FIL for the block design SPM  
% tutorial and will run the basic preprocessing, FFX and contrasts on it.
% Results might be a bit different from those in the manual as some
% default options are slightly different in this pipeline (e.g use of FAST
% instead of AR(1))

clear
clc
close all

% Smoothing to apply
FWHM = 6;

% URL of the data set to download
URL = 'http://www.fil.ion.ucl.ac.uk/spm/download/data/MoAEpilot/MoAEpilot.bids.zip';

WD = pwd; % the directory with this script becomes the current directory
addpath(genpath(WD)) % we add all the subfunctions that are in the sub directories


%% Set options
opt = getOption();

% respecify options here in case the getOption file has been modified on
% the repository
opt.derivativesDir = fullfile(WD, '..', 'output', 'MoAEpilot'); % the dataset will downloaded and analysed there
opt.groups = {''}; % no specific group
opt.subjects = {1};  % first subject
opt.taskName = 'auditory'; % task to analyze
opt.contrastList = {...
    {'listening'} ...
    };

% the following options are less important but are added to reset all
% options
opt.numDummies = 0;
opt.STC_referenceSlice = [];
opt.sliceOrder = [];
opt.funcVoxelDims = [];
opt.JOBS_dir = fullfile(opt.derivativesDir, 'JOBS', opt.taskName);


%% Get data
if ~exist(opt.derivativesDir, 'dir')
    [~,~,~] = mkdir(opt.derivativesDir);
end
fprintf('%-40s:', 'Downloading dataset...');
urlwrite(URL, 'MoAEpilot.zip');
unzip('MoAEpilot.zip', fullfile(WD, '..', 'output'));


%% Check dependencies
% If toolboxes are not in the MATLAB Directory and needed to be added to
% the path

% In case some toolboxes need to be added the matlab path, specify and uncomment 
% in the lines below

% toolbox_path = '';
% addpath(fullfile(toolbox_path)

checkDependencies();


%% Run batches
BIDS_rmDummies(opt);
BIDS_STC(opt);
BIDS_SpatialPrepro(opt);
BIDS_Smoothing(FWHM, opt);
BIDS_FFX(1, FWHM, opt);
BIDS_FFX(2, FWHM, opt);

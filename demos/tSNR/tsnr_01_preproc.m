% (C) Copyright 2019 Remi Gau

% example of how to run the spatial preprocessing on data with different
% acquisition protocol

clear;
clc;

download_data = false;

run ../../initCppSpm.m;

opt = tsnr_get_option();

opt.pipeline.type = 'preproc';

bidsCopyInputFolder(opt);

acq = {'2pt0', '2pt5', '3pt0'};
for i = 1:numel(acq)
  opt.query.acq = acq{i};
  bidsSpatialPrepro(opt);
end
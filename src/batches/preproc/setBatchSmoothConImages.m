function matlabbatch = setBatchSmoothConImages(matlabbatch, opt)
  %
  % Creates a batch to smooth all the con images of all subjects
  %
  % USAGE::
  %
  %   matlabbatch = setBatchSmoothConImages(matlabbatch, group, opt)
  %
  % :param matlabbatch:
  % :type matlabbatch:
  % :param group:
  % :type group:
  % :param opt: Options chosen for the analysis. See ``checkOptions()``.
  % :type opt:
  %
  % :returns: - :matlabbatch:
  %
  % (C) Copyright 2019 CPP_SPM developers

  printBatchName('smoothing contrast images', opt);

  for iSub = 1:numel(opt.subjects)

    subLabel = opt.subjects{iSub};

    printProcessingSubject(iSub, subLabel, opt);

    ffxDir = getFFXdir(subLabel, opt);

    conImg = spm_select('FPlist', ffxDir, '^con*.*nii$');
    data = cellstr(conImg);

    matlabbatch = setBatchSmoothing( ...
                                    matlabbatch, ...
                                    opt, ...
                                    data, ...
                                    opt.fwhm.contrast, ...
                                    [spm_get_defaults('smooth.prefix'), ...
                                     num2str(opt.fwhm.contrast)]);

  end

end
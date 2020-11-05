function matlabbatch = setBatchFmriEstimate(matlabbatch)
  
  printBatchName('estimate fmri model');

  matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep( ...
                                                        'fMRI model specification SPM file', ...
                                                        substruct( ...
                                                                  '.', 'val', '{}', {1}, ...
                                                                  '.', 'val', '{}', {1}, ...
                                                                  '.', 'val', '{}', {1}), ...
                                                        substruct('.', 'spmmat'));

  matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
  matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
end
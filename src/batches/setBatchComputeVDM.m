% (C) Copyright 2019 CPP BIDS SPM-pipeline developpers

function matlabbatch = setBatchComputeVDM(matlabbatch, fmapType)
  % matlabbatch = setBatchComputeVDM(type)
  %
  % adapted from spmup get_FM_workflow.m (@ commit
  % 198c980d6d7520b1a996f0e56269e2ceab72cc83)

  switch lower(fmapType)
    case 'phasediff'
      matlabbatch{end + 1}.spm.tools.fieldmap.calculatevdm.subj(1).data.presubphasemag.phase = '';
      matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).data.presubphasemag.magnitude = '';

    case 'phase&mag'
      matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).data.phasemag.shortphase = '';
      matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).data.phasemag.shortmag = '';
      matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).data.phasemag.longphase = '';
      matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).data.phasemag.longmag = '';

    otherwise
      error('This type of field map is not handled: %s', fmapType);
  end

  FM_template = fullfile( ...
                         spm('dir'), ...
                         'toolbox', ...
                         'FieldMap', ...
                         'T1.nii');

  UF = struct( ...
              'method', 'Mark3D', ...
              'fwhm', 10, ...
              'pad', 0, ...
              'ws', 1);

  MF = struct( ...
              'template', {FM_template}, ...
              'fwhm', 5, ...
              'nerode', 2, ...
              'ndilate', 4, ...
              'thresh', 0.5, ...
              'reg', 0.02);

  defaultsval = struct( ...
                       'et', [NaN NaN], ...
                       'maskbrain', 1, ...
                       'blipdir', 1, ... % can be changed
                       'tert', '', ...
                       'epifm', 0, ... % can be changed
                       'ajm', 0, ...
                       'uflags', UF, ...
                       'mflags', MF);

  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).defaults.defaultsval = defaultsval;

  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).session.epi = ''; % value needed
  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).matchvdm = 1;
  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).sessname = 'run';
  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).writeunwarped = 1;
  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).anat = '';
  matlabbatch{end}.spm.tools.fieldmap.calculatevdm.subj(1).matchanat = 0;

end

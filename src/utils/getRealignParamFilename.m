function realignParamFile = getRealignParamFilename(BIDS, subLabel, session, run, opt)
  %
  % Short description of what the function does goes here.
  %
  % USAGE::
  %
  %   realignParamFile = getRealignParamFile(BIDS, subLabel, session, run, opt)
  %
  % :param BIDS:        returned by bids.layout when exploring a BIDS data set.
  % :type BIDS:         structure
  % :param subLabel:       label of the subject ; in BIDS lingo that means that for a file name
  %                     ``sub-02_task-foo_bold.nii`` the subLabel will be the string ``02``
  % :type subLabel:        string
  % :param sessionID:   session label (for `ses-001`, the label will be `001`)
  % :type sessionID:    string
  % :param runID:       run index label (for `run-001`, the label will be `001`)
  % :type runID:        string
  % :param opt:         Mostly used to find the task name.
  % :type opt:          structure
  %
  % :returns: - :realignParamFile: (string)
  %
  % (C) Copyright 2020 CPP_SPM developers

  realignParamFile = bids.query(BIDS, 'data', ...
                                'prefix', 'rp_', ...
                                'sub', subLabel, ...
                                'ses', session, ...
                                'run', run, ...
                                'extension', '.txt', ...
                                'task', opt.taskName);

  if numel(realignParamFile) > 1
    error('too many files');
  end
  realignParamFile = realignParamFile{1};

end
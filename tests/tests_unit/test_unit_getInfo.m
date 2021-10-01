% (C) Copyright 2020 CPP_SPM developers

function test_suite = test_unit_getInfo %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getInfo_basic()

  subLabel = 'ctrl01';

  opt = setOptions('vismotion', subLabel);

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  sessions = getInfo(BIDS, subLabel, opt, 'sessions');
  assertEqual(sessions, {'01' '02'});

  runs = getInfo(BIDS, subLabel, opt, 'runs', sessions{1});
  assertEqual(runs, {'1' '2'});

  % same but exclude anything with the acquisition entitty
  opt.query = struct('acq', '');

  sessions = getInfo(BIDS, subLabel, opt, 'sessions');
  assertEqual(sessions, {'01' '02'});

  runs = getInfo(BIDS, subLabel, opt, 'runs', sessions{1});
  assertEqual(runs, {'1' '2'});

end

function test_getInfo_query()

  subLabel = 'ctrl01';
  session =  '01';
  run = '1';
  info = 'filename';

  opt = setOptions('vismotion', subLabel);

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  opt.query.desc = 'preproc';
  filename = getInfo(BIDS, subLabel, opt, 'filename', session, run, 'bold');
  assertEqual(size(filename, 1), 2);

  opt.query = struct('acq', '');
  filename = getInfo(BIDS, subLabel, opt, 'filename', session, run, 'bold');
  assert(all(cellfun('isempty', strfind(cellstr(filename), '_acq-')))); %#ok<STRCL1>

  p.suffix = 'bold';
  p.ext = '.nii';
  p.entities = struct('sub', subLabel, ...
                      'ses', session, ...
                      'task', opt.taskName, ...
                      'run', run, ...
                      'acq', '1p60mm', ...
                      'dir', 'PA');
  p.use_schema = true;

  opt.query = struct('acq', '1p60mm', 'dir', 'PA');
  filename = getInfo(BIDS, subLabel, opt, 'filename', session, run, 'bold');

  FileName = returnFullpathExpectedFilename(p);

  assertEqual(filename, FileName);

end

function test_getInfo_no_run()

  %% Get runs from BIDS when no run in filename
  subLabel = 'ctrl01';

  opt = setOptions('vislocalizer');

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  sessions = getInfo(BIDS, subLabel, opt, 'sessions');
  assertEqual(sessions, {'01' '02'});

  runs = getInfo(BIDS, subLabel, opt, 'runs', sessions{1});
  assertEqual(runs, {''});

end

function test_getInfo_no_session_no_run()

  subLabel = '01';

  opt = setOptions('MoAE-preproc', subLabel);
  opt.dir.input = opt.dir.preproc;

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  sessions = getInfo(BIDS, subLabel, opt, 'sessions');
  assertEqual(sessions, {''});

  runs = getInfo(BIDS, subLabel, opt, 'runs', sessions);
  assertEqual(runs, {''});

end

function test_getInfoQuery_with_session_restriction()

  subLabel = 'ctrl01';

  opt = setOptions('vismotion', subLabel);

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  opt.query = struct('ses', {{'01', '02'}});
  [~, nbSessions] = getInfo(BIDS, subLabel, opt, 'sessions');
  assertEqual(nbSessions, numel(opt.query.ses));

  opt.query = struct('ses', '02');
  [sessions, nbSessions] = getInfo(BIDS, subLabel, opt, 'sessions');
  assertEqual(nbSessions, numel(opt.query));
  assertEqual(sessions{1}, opt.query.ses);

end

function test_getInfo_error

  subLabel = 'ctrl01';

  opt = setOptions('vismotion', subLabel);

  [BIDS, opt] = getData(opt, opt.dir.preproc);

  opt.query = struct('ses', {{'01', '02'}});

  assertExceptionThrown( ...
                        @()getInfo(BIDS, subLabel, opt, 'nothing'), ...
                        'getInfo:unknownRequest');

end

function FileName = returnFullpathExpectedFilename(p)
  FileName = fullfile(getDummyDataDir(), 'derivatives', 'cpp_spm-preproc', ...
                      bids.create_path(bids.create_filename(p)), ...
                      bids.create_filename(p));
end
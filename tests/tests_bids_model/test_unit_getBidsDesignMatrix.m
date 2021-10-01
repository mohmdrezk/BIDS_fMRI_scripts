% (C) Copyright 2021 CPP_SPM developers

function test_suite = test_unit_getBidsDesignMatrix %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_getBidsDesignMatrix_basic()

  modelFile = fullfile(getDummyDataDir(), 'models', 'model-vismotion_smdl.json');
  X = getBidsDesignMatrix(modelFile, 'subject');

  expected = {
              'trial_type.VisUp'; ...
              'trial_type.VisDown'; ...
              'trans_x'; ...
              'trans_y'; ...
              'trans_z'; ...
              'rot_x'; ...
              'rot_y'; ...
              'rot_z'
             };
  assertEqual(X, expected);

end
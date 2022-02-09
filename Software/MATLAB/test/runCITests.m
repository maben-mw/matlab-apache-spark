function runCITests(name)
    import matlab.unittest.TestRunner;
    import matlab.unittest.Verbosity;
    import matlab.unittest.plugins.XMLPlugin;
    import matlab.unittest.selectors.HasName;
    import matlab.unittest.constraints.StartsWithSubstring;
    
    % Generate a suite with all tests
    suite = matlab.unittest.TestSuite.fromFolder('../../../Modules/matlab-spark-api/Software/MATLAB/test/unit');

    % Filter out tests which require a MATLAB Compiler SDK license
    suite = suite.selectIf(~HasName(StartsWithSubstring('testSparkBuilder')));

    % Configure for JUnit XML reporting
    [~,~] = mkdir('../../../test-results');

    runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed);
    runner.addPlugin(XMLPlugin.producingJUnitFormat(['../../../test-results/' name '.xml']));

    % Run the suite
    results = runner.run(suite);

    % Assert that none of the tests failed
    nfailed = nnz([results.Failed]);
    assert(nfailed == 0, [num2str(nfailed) ' test(s) failed.']);
classdef test_atmosEarth < matlab.unittest.TestCase
    % test_atmosEarth   Unit tests for the atmosEarth function.
    %
    % To run:
    %   1. Navigate to the 'Kinetic-Launch' root directory.
    %   2. Add src to path: >> addpath('src');
    %   3. Run tests: >> runtests('tests')

    methods (Test)
        function testSeaLevelDensity(testCase)
            % Test that the density at sea level is the expected value.
            import launchsim.atmosEarth;
            [rho, ~, ~] = atmosEarth(0);
            testCase.verifyEqual(rho, 1.225, 'AbsTol', 1e-4);
        end

        function testHighAltitudeDensity(testCase)
            % Density should be zero far beyond the model's limits.
            import launchsim.atmosEarth;
            [rho, ~, ~] = atmosEarth(100e3); % 100 km
            testCase.verifyEqual(rho, 0, 'AbsTol', 1e-4);
        end
    end
end
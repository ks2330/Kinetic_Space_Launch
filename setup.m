%% setup.m - Configure Kinetic Launch environment
% This script adds all necessary directories to the MATLAB path
% to enable the project to run without manual path management.
%
% Usage:
%   >> setup

function setup()
    % Get the directory containing this script
    project_root = fileparts(mfilename('fullpath'));
    
    % Add core source directories to path
    addpath(fullfile(project_root, 'src'));
    addpath(fullfile(project_root, 'tests'));
    addpath(fullfile(project_root, 'extension'));
    
    % Optional: Add examples if it exists
    if isfolder(fullfile(project_root, 'examples'))
        addpath(fullfile(project_root, 'examples'));
    end
    
    % Display confirmation
    fprintf('✓ Kinetic Launch environment configured\n');
    fprintf('  - Source paths added\n');
    fprintf('  - Tests available via: runtests(''tests'')\n');
    fprintf('\n');
end

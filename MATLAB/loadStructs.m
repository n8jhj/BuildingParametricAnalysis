function buildings = loadStructs(source, params)
%LOADSTRUCTS Load all building data. Takes approximately 20 seconds for
%EnergyPlus Standard Output (ESO) data, 5 minutes for New York State Energy
%Research and Development Authority (NYSERDA) data.
% buildings = LOADSTRUCTS(source[, params])
%   Returns struct containing all building data from the specified source.
%   source -    Either 'ESO' or 'NYSERDA', if starting from scratch.
%               However, if an error was previously encountered, source may
%               be a struct of the buildings that were returned at the end
%               of the last run.
%   params -    Other optional input parameters put into a struct with the
%               following field names:
%       bldgs - Struct containing building information from a previous run
%               in which an error was encountered.
%       start - Either a number that indicates which file number to start
%               with for data import or a string that indicates which name
%               to start with for field addition. This is used when an
%               error was encountered during a previous run and the user
%               would now like to start loading from where they left off.

%% Check input
if isstruct(source)
    % start adding fields
    fetchBldgData = false;
    flag = 0;
    buildings = source;
else
    % check string input
    assert(strcmp(source,'ESO') || strcmp(source,'NYSERDA'), ...
        'Source not recognized')
    % start importing data
    fetchBldgData = true;
end

%% Start timer
tic

%% Import building data
if fetchBldgData
    fprintf('Begin fetching building data...\n')
    % Get list of building data file names from proper directory
    bldgFiles = getBldgFiles(source);
    % Load building data from list of file names
    if nargin < 2
        params.start = 1;
    end
    [buildings, flag] = loadBldgData(bldgFiles,source,params);
end

%% Add fields to buildings
if ~flag % flag of 0 means everything is going smoothly
    fprintf('Begin adding fields to input buildings...\n')
    fields = {...
        'days',...      days
        'nsteps',...    number timesteps
        'mads',...      monthly average days
        'avgDay',...    average day
        'omean',...     overall mean
        'tdr',...       turndown ratios
        'avgTdr',...    average turndown ratio
        'nomRng',...    nominal ranges
        'avgNomRng',... average nominal range
        'pkOtlrs',...   peak outliers
        };
    % Check for initField
    if nargin > 1 && ischar(params.start)
        startIndex = find(strcmp(fields, params.start));
        fields = {fields{startIndex:end}};
    end
    addFields(fields);
end

%% Final time
fprintf('Done - ')
toc


%% Internal functions

% Get list of building data files
function bldgFiles = getBldgFiles(source)
switch source
    case 'ESO'
        dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
            '\BuildingParametricAnalysis\EPLUS_datafiles\4A');
    case 'NYSERDA'
        dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
            '\BuildingParametricAnalysis\NYSERDA_select');
end
bldgFiles = dir(dirName);
end


% Load building data from .csv files
function [buildings, flag] = loadBldgData(bldgFiles,source,params)
% Retain changes made up to a potential error
flag = 0;
if params.start == 1
    buildings = struct('name',{}, 'data',{});
else
    buildings = params.bldgs;
end
bLen = length(bldgFiles);
count = 0;
for b = 1:1:bLen
    fprintf('File %03i of %03i --> ', b,bLen)
    try
        if ~strcmp(bldgFiles(b).name, '.') && ~strcmp(bldgFiles(b).name, '..')
            if b >= params.start
                fName = char(bldgFiles(b).name);
                sName = erase(fName, '.csv');
                switch source
                    case 'ESO'
                        data = ESO_importToStruct(fName);
                    case 'NYSERDA'
                        data = NYSERDA_importToStruct(fName);
                end
                buildings(b-count) = struct(...
                    'name', sName, ...
                    'data', data);
            end
        else
            count = count + 1;
        end
        toc
    catch ME
        printError(ME)
        fprintf(['Error at import of file %03i.\n', ...
            'Please fix the error, then run the following:\n\n', ...
            'params.bldgs = buildings;\n', ...
            'params.start = %i;\n', ...
            'buildings = ', mfilename, '(''', source, ''', params);\n\n', ...
            'Returning buildings loaded up to this point...\n'], b, b)
        flag = 1;
        return
    end
end
end


% Add list of fields to buildings
function addFields(fields)
% Retain changes made up to a potential error
% Add each field to all buildings
for f = 1:1:length(fields)
    fn = fields{f};
    fprintf('Field %s --> ', fn)
    [buildings, flagAddFields] = addToBuildings(buildings,fn);
    if flagAddFields
        fprintf(['Error at field ''%s'' in file ', mfilename, '\n', ...
            'Please fix the error, then run the following:\n\n', ...
            'params.start = ''%s'';\n', ...
            'buildings = ', mfilename, '(buildings, params);\n\n'], ...
            fn, fn)
        break
    end
    toc
end
end

end

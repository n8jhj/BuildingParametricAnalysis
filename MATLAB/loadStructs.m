function loadStructs(source)
%LOADSTRUCTS Load all building data. Takes approximately 20 seconds for
%EnergyPlus Standard Output data (ESO), 5 minutes for New York State Energy
%Research and Development Authority (NYSERDA) data.
%   buildings = loadStructs(source)
%   Returns struct containing all building data from the specified source.
%   SOURCE should be either 'ESO' or 'NYSERDA'.

%% Check input
assert(strcmp(source,'ESO') || strcmp(source,'NYSERDA'), ...
    'Source not recognized')

%% Start timer
tic

%% Get list of building data files from proper directory
bldgFiles = getBldgFiles(source);

%% Load building data from list of file names
loadBldgData(bldgFiles,source);

%% Add fields to buildings
fields = {...
    'days',... days
    'nsteps',... number timesteps
    'mads',... monthly average days
    'avgDay',... average day
    'omean',... overall mean
    'tdr',... turndown ratios
    'avgTdr',... average turndown ratio
    'nomRng',... nominal ranges
    'avgNomRng',... average nominal range
    'pkOtlrs',... peak outliers
    };
addFields(fields);

%% Final time
fprintf('Done - ')
toc

%% Further instructions to user
fprintf(strcat('\n\nTo see the loaded buildings in the workspace,', ...
    ' type:\nglobal buildings\n\n'))

end


%% Get list of building data files
function bldgFiles = getBldgFiles(source)
switch source
    case 'ESO'
        dirName = strcat('C:\\Users\Admin\Documents\07_Grad Yr 2\Work', ...
            '\BuildingParametricAnalysis\PAT_datafiles', ...
            '\CharacterizationStudy\4A');
    case 'NYSERDA'
        dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
            '\BuildingParametricAnalysis\NYSERDA_select');
end
bldgFiles = dir(dirName);
end


%% Load building data from .csv files
function loadBldgData(bldgFiles,source)
%% Retain changes made up to a potential error
global buildings

buildings = struct('name',{}, 'data',{});
bLen = length(bldgFiles);
count = 0;
for b = 1:1:bLen
    if ~strcmp(bldgFiles(b).name, '.') && ~strcmp(bldgFiles(b).name, '..')
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
    else
        count = count + 1;
    end
    fprintf('File %i of %i - ', b,bLen)
    toc
end
end


%% Add list of fields to buildings
function addFields(fields)
%% Retain changes made up to a potential error
global buildings

%% Add each field to all buildings
for f = 1:1:length(fields)
    fn = fields{f};
    buildings = addToBuildings(buildings,fn);
    fprintf('Added field %s - ', fn)
    toc
end
end

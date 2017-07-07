function buildings = loadStructs(source)
%LOADSTRUCTS Load all building data. Takes approximately 20 seconds for
%EnergyPlus Standard Output data (ESO), 5 minutes for New York State Energy
%Research and Development Authority (NYSERDA) data.
%   buildings = loadStructs(source)
%   Returns struct containing all building data from the specified source.
%   SOURCE should be either 'ESO' or 'NYSERDA'.

%% Get into proper directory
switch source
    case 'ESO'
        dirName = strcat('C:\\Users\Admin\Documents\07_Grad Yr 2\Work', ...
            '\BuildingParametricAnalysis\PAT_datafiles\CharacterizationStudy', ...
            '\csv_files');
    case 'NYSERDA'
        dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
            '\BuildingParametricAnalysis\NYSERDA_select');
    otherwise
        error('Source not recognized')
end

%% Load data
bldgList = dir(dirName);
buildings = struct('name',{}, 'data',{});
bLen = length(bldgList);
count = 0;
tic
for b = 1:1:bLen
    if ~strcmp(bldgList(b).name, '.') && ~strcmp(bldgList(b).name, '..')
        fName = char(bldgList(b).name);
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
    fprintf('Building %i of %i - ', b,bLen)
    toc
end

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
    };
buildings = addFields(buildings,fields);

%% Final time
fprintf('Done - ')
toc

end

function buildings = addFields(buildings,fields)
for f = 1:1:length(fields)
    fn = fields{f};
    buildings = addToBuildings(buildings,fn);
    fprintf('Added field %s - ', fn)
    toc
end
end

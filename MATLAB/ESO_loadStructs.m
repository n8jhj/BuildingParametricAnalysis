function loadStructs(source)
%LOADSTRUCTS Load all building data. Takes approximately 20 seconds for
%EnergyPlus Standard Output data (ESO), 5 minutes for New York State Energy
%Research and Development Authority (NYSERDA) data.

%% Get into proper directory
switch source
    case 'ESO'
    case 'NYSERDA'
    otherwise
        error('Source not recognized')
end
dirName = strcat('C:\\Users\Admin\Documents\07_Grad Yr 2\Work', ...
    '\BuildingParametricAnalysis\PAT_datafiles\CharacterizationStudy', ...
    '\csv_files');
bldgList = dir(dirName);

%% Load data
tic
bESO = struct('name',{}, 'data',{});
bLen = length(bldgList);
count = 0;
for b = 1:1:bLen
    if ~strcmp(bldgList(b).name, '.') && ~strcmp(bldgList(b).name, '..')
        fName = char(bldgList(b).name);
        sName = erase(fName, '.csv');
        bESO(b-count) = struct(...
            'name', sName, ...
            'data', ESO_importToStruct(fName));
    else
        count = count + 1;
    end
    fprintf('Building %i of %i - ', b,bLen)
    toc
end

%% Clear extraneous variables
clear dirName
clear dataList
clear bldgList
clear count
clear fName
clear sName
clear i

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
bESO = addFields(bESO,fields);

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

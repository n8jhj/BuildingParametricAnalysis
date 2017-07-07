%NYSERDA_LOADSTRUCTS Load all data in folder 'NYSERDA_select'. Takes
%approximately 5 minutes.

%% Get into proper directory

bldgList = dir(dirName);

%% Load data
tic
bNYSERDA = struct('name',{}, 'data',{});
count = 0;
for i = 1:1:length(bldgList)
    if ~strcmp(bldgList(i).name, '.') && ~strcmp(bldgList(i).name, '..')
        fName = char(bldgList(i).name);
        sName = erase(fName, '.csv');
        bNYSERDA(i-count) = struct(...
            'name', sName, ...
            'data', NYSERDA_importToStruct(fName));
    else
        count = count + 1;
    end
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
bNYSERDA = addFields(bNYSERDA,fields);

%% Final time
fprintf('Done - ')
toc

function buildings = addFields(buildings,fields)
for f = 1:1:length(fields)
    fn = fields{f};
    buildings = addToBuildings(buildings,fn);
    fprintf('Added field %s - ', fn)
    toc
end
end

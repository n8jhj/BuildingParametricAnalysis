%NYSERDA_LOADSTRUCTS Load all data in folder 'NYSERDA_select'. Takes
%approximately 5 minutes.

%% Get into proper directory
dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
    '\BuildingParametricAnalysis\NYSERDA_select');
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

%% Add fields...
% days
bNYSERDA = addDaysToBuildings(bNYSERDA);
% timestep
bNYSERDA = addTimestepToBuildings(bNYSERDA);
% turndown ratios
bNYSERDA = addTDRsToBuildings(bNYSERDA);
bNYSERDA = addAvgTDRToBuildings(bNYSERDA);
% mean average days
bNYSERDA = addMADsToBuildings(bNYSERDA);
% average day
bNYSERDA = addAvgDayToBuildings(bNYSERDA);

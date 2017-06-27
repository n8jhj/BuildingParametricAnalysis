%NYSERDA_LOADSTRUCTS Load all data in folder 'NYSERDA_select'. Takes
%approximately 5 minutes.

%% Get into proper directory
dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
    '\BuildingParametricAnalysis\NYSERDA_select');
bldgList = dir(dirName);

%% Load data
tic
NYSERDA_buildings = struct('name',{}, 'data',{});
count = 0;
for i = 1:1:length(bldgList)
    if ~strcmp(bldgList(i).name, '.') && ~strcmp(bldgList(i).name, '..')
        fName = char(bldgList(i).name);
        sName = erase(fName, '.csv');
        NYSERDA_buildings(i-count) = struct(...
            'name', sName, ...
            'data', NYSERDA_importToStruct(fName));
    else
        count = count + 1;
    end
    toc
end

%% Clear extraneous variables
clear dataList
clear bldgList
clear fName
clear sName
clear i

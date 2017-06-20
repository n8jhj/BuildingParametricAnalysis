%LOADSTRUCTSNYSERDA Load all data in folder 'NYSERDA_select'. Takes
%approximately 5 minutes.

%% Get into proper directory
cd 'C:\Users\Admin\Documents\GitHub\BuildingParametricAnalysis\NYSERDA_select'
bldgList = dir;

%% Load data
tic
buildings = struct('name',{}, 'data',{});
for i = 1:1:length(bldgList)
    if ~strcmp(bldgList(i).name, '.') && ~strcmp(bldgList(i).name, '..')
        fName = char(bldgList(i).name);
        sName = erase(fName, {'.csv', ' '});
        buildings(end+1) = struct(...
            'name', sName, ...
            'data', NYSERDA_importToStruct(fName));
    end
    toc
end

%% Clear extraneous variables
clear dataList
clear bldgList
clear fName
clear sName
clear i

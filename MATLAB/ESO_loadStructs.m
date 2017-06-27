%ESO_LOADSTRUCTS Load all data in specified directory. Takes approximately
%5 minutes.

%% Get into proper directory
dirName = strcat('C:\\Users\Admin\Documents\07_Grad Yr 2\Work', ...
    '\BuildingParametricAnalysis\PAT_datafiles\CharacterizationStudy', ...
    '\csv_files');
bldgList = dir(dirName);

%% Load data
tic
ESO_buildings = struct('name',{}, 'data',{});
count = 0;
for i = 1:1:length(bldgList)
    if ~strcmp(bldgList(i).name, '.') && ~strcmp(bldgList(i).name, '..')
        fName = char(bldgList(i).name);
        sName = erase(fName, '.csv');
        ESO_buildings(i-count) = struct(...
            'name', sName, ...
            'data', ESO_importToStruct(fName));
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
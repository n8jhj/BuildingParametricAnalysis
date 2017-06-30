%ESO_LOADSTRUCTS Load all data in specified directory. Takes approximately
%12 seconds.

%% Get into proper directory
dirName = strcat('C:\\Users\Admin\Documents\07_Grad Yr 2\Work', ...
    '\BuildingParametricAnalysis\PAT_datafiles\CharacterizationStudy', ...
    '\csv_files');
bldgList = dir(dirName);

%% Load data
tic
bESO = struct('name',{}, 'data',{});
count = 0;
for i = 1:1:length(bldgList)
    if ~strcmp(bldgList(i).name, '.') && ~strcmp(bldgList(i).name, '..')
        fName = char(bldgList(i).name);
        sName = erase(fName, '.csv');
        bESO(i-count) = struct(...
            'name', sName, ...
            'data', ESO_importToStruct(fName));
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
bESO = addDaysToBuildings(bESO);
% number timesteps
bESO = addNStepsToBuildings(bESO);
% monthly average days
bESO = addMADsToBuildings(bESO);
% average day
bESO = addAvgDayToBuildings(bESO);
% overall mean
bESO = addOMeanToBuildings(bESO);
% turndown ratios
bESO = addTDRsToBuildings(bESO);
bESO = addAvgTDRToBuildings(bESO);
% nominal ranges
bESO = addNominalRangesToBuildings(bESO);
bESO = addAvgNomRngToBuildings(bESO);

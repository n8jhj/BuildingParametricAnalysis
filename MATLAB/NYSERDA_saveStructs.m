
%% Source data folder
csvFolder = strcat('C:\Users\Admin\Documents\GitHub', ...
    '\BuildingParametricAnalysis\NYSERDA_select');
matFolder = strcat('C:\Users\Admin\Documents\GitHub', ...
    '\BuildingParametricAnalysis\MATLAB\NYSERDA_select');

%% Load and save
dataDir = dir(csvFolder);
for i = 1:1:length(dataDir)
    csvFileName = dataDir(i).name;
    if ~(strcmp(csvFileName,'.') || strcmp(csvFileName,'..'))
        data = NYSERDA_importToStruct(csvFileName);
        matFileName = strjoin(strsplit(strrep(csvFileName,'.csv','')), '');
        matFileName = strcat(matFolder, '\', matFileName);
        save(matFileName, 'data')
    end
end

%SAVE_ESO Save EnergyPlus buildings.

dirName = strcat('C:\\Users\Admin\Documents\GitHub', ...
    '\BuildingParametricAnalysis\EPLUS_datafiles\4A');
bldgFiles = dir(dirName);

for i = 1:1:length(bldgFiles)
    bldgFileName = bldgFiles(i).name;
    if ~(strcmp(bldgFileName,'.') || strcmp(bldgFileName,'..'))
        bldgName = replace(bldgFileName,'.csv','');
        data = ESO_importToStruct(bldgFileName);
        save([bldgName,'.mat'], 'data')
    end
end
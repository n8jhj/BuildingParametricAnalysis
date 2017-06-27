function dataStruct = ESO_importToStruct(filename)
%ESO_IMPORTTOSTRUCT Import an EnergyPlus output datafile to a struct.
%   dataStruct = ESO_importToStruct(filename)
%   Reads data from the file FILENAME to DATASTRUCT using the function
%   ESO_importFile.

%% Create struct from NYSERDA_importFile output.
[Timestamp,TotFacilityEnergy] = ESO_importFile(filename);
dataStruct = struct('timestamp',Timestamp, ...
    'totFacEn',TotFacilityEnergy);
end

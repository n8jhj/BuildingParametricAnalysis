function dataStruct = NYSERDA_importToStruct(filename)
%NYSERDA_IMPORTTOSTRUCT Import a datafile from the NYSERDA CHP database to
%a struct.
%   dataStruct = NYSERDA_importToStruct(filename) Reads data from the file
%   FILENAME to DATASTRUCT using the function NYSERDA_importFile.

%% Create struct from NYSERDA_importFile output.
[Timestamp,TotFacilityEnergy,TotFacilityDemand,~,~] ...
    = NYSERDA_importFile(filename);
dataStruct = struct('timestamp',Timestamp, ...
    'totFacEn',TotFacilityEnergy, ...
    'totFacDe',TotFacilityDemand);
end
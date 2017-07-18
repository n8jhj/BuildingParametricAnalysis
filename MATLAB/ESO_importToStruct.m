function dataStruct = ESO_importToStruct(filename)
%ESO_IMPORTTOSTRUCT Import an EnergyPlus output datafile to a struct.
%   dataStruct = ESO_importToStruct(filename)
%   Reads data from the file FILENAME to DATASTRUCT using the function
%   ESO_importFile.

%% Create struct from NYSERDA_importFile output.
% get data values
[Timestamp,TotFacilityEnergy] = ESO_importFile(filename);
% convert ESO buildings demand: J to kWh
TotFacilityEnergy_kwh = TotFacilityEnergy ./ 3600000;
% return struct
dataStruct = struct('timestamp',Timestamp, ...
    'totFacEn',TotFacilityEnergy_kwh);
end

function [Timestamp,ElectricityNetFacility,HeatingElectricity,HeatingGas,FansElectricity,InteriorLightsElectricity,WaterSystemsElectricity,ElectricityPurchasedFacility,ExteriorLightsElectricity,PumpsElectricity,ElectricityHVAC,GasFacility,GasHVAC,InteriorEquipmentElectricity,ElectricityFacility,WaterHeaterWaterSystemsElectricity,CoolingElectricity] = MTR_importFile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [DATETIME,ELECTRICITYNETFACILITY,HEATINGELECTRICITY,HEATINGGAS,FANSELECTRICITY,INTERIORLIGHTSELECTRICITY,WATERSYSTEMSELECTRICITY,ELECTRICITYPURCHASEDFACILITY,EXTERIORLIGHTSELECTRICITY,PUMPSELECTRICITY,ELECTRICITYHVAC,GASFACILITY,GASHVAC,INTERIOREQUIPMENTELECTRICITY,ELECTRICITYFACILITY,WATERHEATERWATERSYSTEMSELECTRICITY,COOLINGELECTRICITY]
%   = MTR_IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [DATETIME,ELECTRICITYNETFACILITY,HEATINGELECTRICITY,HEATINGGAS,FANSELECTRICITY,INTERIORLIGHTSELECTRICITY,WATERSYSTEMSELECTRICITY,ELECTRICITYPURCHASEDFACILITY,EXTERIORLIGHTSELECTRICITY,PUMPSELECTRICITY,ELECTRICITYHVAC,GASFACILITY,GASHVAC,INTERIOREQUIPMENTELECTRICITY,ELECTRICITYFACILITY,WATERHEATERWATERSYSTEMSELECTRICITY,COOLINGELECTRICITY]
%   = MTR_IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [Timestamp,ElectricityNetFacility,HeatingElectricity,HeatingGas,FansElectricity,InteriorLightsElectricity,WaterSystemsElectricity,ElectricityPurchasedFacility,ExteriorLightsElectricity,PumpsElectricity,ElectricityHVAC,GasFacility,GasHVAC,InteriorEquipmentElectricity,ElectricityFacility,WaterHeaterWaterSystemsElectricity,CoolingElectricity] = MTR_importFile('MTR_SmallOffice-90.1-2010-ASHRAE 169-2006-4A.csv',2, 8761);
%
%    See also TEXTSCAN.

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
Timestamp = datetime(dataArray{:, 1},'InputFormat','MM/dd  HH:mm:ss');
ElectricityNetFacility = dataArray{:, 2};
HeatingElectricity = dataArray{:, 3};
HeatingGas = dataArray{:, 4};
FansElectricity = dataArray{:, 5};
InteriorLightsElectricity = dataArray{:, 6};
WaterSystemsElectricity = dataArray{:, 7};
ElectricityPurchasedFacility = dataArray{:, 8};
ExteriorLightsElectricity = dataArray{:, 9};
PumpsElectricity = dataArray{:, 10};
ElectricityHVAC = dataArray{:, 11};
GasFacility = dataArray{:, 12};
GasHVAC = dataArray{:, 13};
InteriorEquipmentElectricity = dataArray{:, 14};
ElectricityFacility = dataArray{:, 15};
WaterHeaterWaterSystemsElectricity = dataArray{:, 16};
CoolingElectricity = dataArray{:, 17};

%% Handle NaT values in Timestamp
step = 1/24;
natInds = find(isnat(Timestamp));
for i = natInds
    Timestamp(i) = Timestamp(i-1) + step;
end

end

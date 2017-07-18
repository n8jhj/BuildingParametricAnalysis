function [DateTime,ElectricityFacility] = ESO_importFile(filename, startRow, endRow)
%ESO_IMPORTFILE Import numeric EnergyPlus data from a CSV file as column
%vectors.
%   [DATETIME,ELECTRICITYFACILITY] = ESO_IMPORTFILE(FILENAME) Reads data
%   from text file FILENAME for the default selection.
%
%   [DATETIME,ELECTRICITYFACILITY]
%   = ESO_IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of CSV file FILENAME.
%
% Example:
%   [DateTime,ElectricityFacility] = ESO_importFile('eplusout_2.csv');
%
%    See also TEXTSCAN.

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Open the text file.
fileID = fopen(filename,'r');

%% Format for each line of text:
% get number of columns using the first row of data
firstLine = fgetl(fileID);
commas = strfind(firstLine, ',');
nCols = length(commas) - 1;
formatCell = cell(nCols,1);
formatCell(:) = {'%f'};
formatSpec = strcat('%s%s', formatCell{:});

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+2, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
% get time data
DateTime = datetime(dataArray{:, 1}, 'InputFormat', 'MM/dd  HH:mm:ss');

% handle NaT values due to hour 24:00:00 instead of 00:00:00
if ~isnat(DateTime(1))
    day1 = ceil(datenum(DateTime(1)));
else
    day1 = floor(datenum(DateTime(2)));
end
if ~isnat(DateTime(end))
    dayEnd = floor(datenum(DateTime(end)));
else
    dayEnd = ceil(datenum(DateTime(end-1)));
end
midnights = day1:1:dayEnd;
DateTime(isnat(DateTime)) = datetime(midnights, 'ConvertFrom', 'datenum');

% get facility data
ElectricityFacility = dataArray{:, end-1};
end

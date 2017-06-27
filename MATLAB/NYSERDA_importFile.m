function [Timestamp,TotFacilityEnergy,TotFacilityDemand,DataQualTFE,...
    DataQualTFD] = NYSERDA_importFile(filename, startRow, endRow)
%NYSERDA_IMPORTFILE Import numeric data from a text file as column vectors.
%   [Timestamp,TotFacilityEnergy,TotFacilityDemand,DataQualTFE,DataQualTFD]
%   = NYSERDA_importFile(filename) Reads data from text file filename for
%   the default selection.
%
%   [Timestamp,TotFacilityEnergy,TotFacilityDemand,DataQualTFE,DataQualTFD]
%   = NYSERDA_importFile(filename, startRow, endRow) Reads data from rows
%   startRow through endRow of text file filename.
%
% Example:
%   [Timestamp,TotFacilityEnergy,TotFacilityDemand,DataQualTFE,DataQualTFD] = NYSERDA_importFile('Pepsi Co. - College Point, NY.csv', 5, 61182);
%
%    See also TEXTSCAN.

%% Initialize variables.
if nargin<=2
    startRow = 5;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%11s%11s%13s%13s%13s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, ...
    'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(1)-1, ...
    'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Remove white space around all cell columns.
dataArray{1} = strtrim(dataArray{1});
dataArray{2} = strtrim(dataArray{2});

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[3,4,5,6]
    % Converts text in the input cell array to numbers. Replaced
    % non-numeric text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric
        % prefixes and suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

%% Split data into numeric and cell columns while combining date and time.
rawNumericColumns = raw(:, [3,4,5,6]);
rawCellColumns = strcat(raw(:,1), raw(:,2));

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Convert the contents of first and second columns into datetime.
rawCellColumns = datetime(rawCellColumns, 'InputFormat', 'MM/dd/yyyy,HH:mm:ss,');

%% Allocate imported array to column variable names
Timestamp = rawCellColumns;
TotFacilityEnergy = cell2mat(rawNumericColumns(:, 1));
TotFacilityDemand = cell2mat(rawNumericColumns(:, 2));
DataQualTFE = cell2mat(rawNumericColumns(:, 3));
DataQualTFD = cell2mat(rawNumericColumns(:, 4));
end

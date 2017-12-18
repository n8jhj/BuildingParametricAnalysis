function [timestamp, meters] = MTR_importFile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [timestamp, meters] = MTR_IMPORTFILE(FILENAME) Reads data from text
%   file FILENAME for the default selection.
%
%   [timestamp, meters] = MTR_IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads
%   data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [timestamp, meters] = MTR_importFile('MTR_SmallOffice-90.1-2010-ASHRAE 169-2006-4A.csv',2, 8761);
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

%% Get headers.
% read headers
headers = cell(1);
nh = NaN;
i = 1;
while true
    h = textscan(fileID,'%s',1,'Delimiter',delimiter);
    if ~isnan(str2double(h{1}{1}(1)))
        nh = i-1;
        break
    end
    headers{i} = h;
    i = i+1;
end
headers = cellfun(@(x) x{1}{1}, headers, 'UniformOutput',false);
% format headers
[headers, headerUnits] = format_headers(headers);

%% Format for each line of text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s';
for i = 1:1:nh-1
    formatSpec = strcat(formatSpec,'%f');
end
formatSpec = strcat(formatSpec,'%[^\n\r]');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
frewind(fileID);
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

%% Create return data structure
timestamp = datetime(dataArray{:, 1},'InputFormat','MM/dd  HH:mm:ss');
meters = cell(nh-1,3);
for i = 2:1:nh
    meters{i-1,1} = headers{i};
    meters{i-1,2} = headerUnits{i};
    meters{i-1,3} = dataArray{:, i};
end

%% Handle NaT values in timestamp
natInds = find(isnat(timestamp));
step = timestamp(2) - timestamp(1);
for i = natInds
    timestamp(i) = timestamp(i-1) + step;
end

end


%% Internal functions

% Format headers for use as struct field names
function [headers, headerUnits] = format_headers(headers)

headerUnits = cell(size(headers));

for i = 1:1:length(headers)
    header = headers{i};
    iLeftBracket = max(strfind(header, '['));
    iRightBracket = max(strfind(header, ']'));
    headerUnits{i} = header(iLeftBracket+1 : iRightBracket-1);
    strToErase = header(iLeftBracket : end);
    newHeader = erase(header, strToErase);
    newHeader = erase(newHeader, ':'); % remove ':'
    headers{i} = erase(newHeader, ' '); % remove ' '
end

end

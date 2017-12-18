function dataStruct = MTR_importToStruct(filename, hourlyTimesteps)
%MTR_IMPORTTOSTRUCT Import an EnergyPlus output .mtr datafile to a struct.
%   dataStruct = ESO_importToStruct(filename[, hourlyTimesteps])
%   Reads data from the file FILENAME to DATASTRUCT using the function
%   MTR_importFile. Optional input HOURLYTIMESTEPS specifies the number of
%   timesteps within one hour of the data in file FILENAME. Default is 1.

%% Handle input
if nargin < 2
    hourlyTimesteps = 1;
end

%% Create struct from MTR_importFile output.
% get data values
[timestamp, meters] = MTR_importFile(filename);
[nMeters,~] = size(meters);
if hourlyTimesteps > 1
    % convert: 10-min intervals -> 1-hr intervals
    nSubHourlyValues = length(meters{1,3});
    indicesToKeep = (hourlyTimesteps : hourlyTimesteps : nSubHourlyValues)';
    timestamp = timestamp(indicesToKeep);
    for i = 1:1:nMeters
        oldMeterValues = meters{i, 3};
        meters{i, 3} = oldMeterValues(indicesToKeep);
    end
end
meterUnits = {meters{:,2}};

% convert E+ buildings demand: J to kWh
kwh = zeros(length(timestamp), nMeters);
for i = 1:1:nMeters
    assert(strcmp(meterUnits{i}, 'J'), 'Output was expected in units J.')
    kwh(:, i) = meters{i, 3};
end
kwh = kwh ./ 3600000;

% return struct
dataStruct = struct(...
    'Name',filename(1:end-4), ...
    'Timestamp',timestamp ...
    );
for i = 1:1:nMeters
    dataStruct.(meters{i,1}) = kwh(:, i);
end

end

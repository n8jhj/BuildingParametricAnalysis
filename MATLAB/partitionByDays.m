function [days, emptyDays] = partitionByDays(data)
%PARTITIONBYDAYS Get input data returned as structure array of the data
%partitioned by days.
%   [days, emptyDays] = partitionByDays(data)
%   Partitions input struct DATA into days using its property TIMESTAMP.
%   DAYS is the partitioned structure array and EMPTYDAYS is an array of
%   datetime values corresponding to the days for which there was no data.

%% Get fieldnames of data
fdNames = fieldnames(data);
fdInd = 'index'; % field to be added to emptyDays struct

%% Check input for field timestamp as first field
assert(strcmp(fdNames{1}, 'timestamp'), ...
    'Input struct DATA must have TIMESTAMP as first field')

%% Preallocate return cell array
tnum = datenum(data.timestamp);
nDays = floor(tnum(end)+1) - floor(tnum(1));
days = struct([]);
for i = 1:1:length(fdNames)
    [days(:).(fdNames{i})] = {};
end

%% Fill return variable with data
currDay = floor(tnum(1));
prevDay = currDay - 1;
nextDay = currDay;
emptyDays = struct(fdNames{1},{}, fdInd,{});
i = 1;
for d = 1:1:nDays
    if currDay == prevDay + 1
        % get range of data for this day
        iFirst = i;
        while nextDay == currDay
            i = i+1;
            if i > length(tnum)
                break
            end
            nextDay = floor(tnum(i));
        end
        iLast = i-1;
        prevDay = currDay;
        currDay = nextDay;
        % create struct with this day's data
        tempStruct = struct(fdNames{1}, data.(fdNames{1})(iFirst:iLast));
        for f = 2:1:length(fdNames)
            tempStruct.(fdNames{f}) = data.(fdNames{f})(iFirst:iLast);
        end
        days(d) = tempStruct;
    else
        prevDay = prevDay + 1;
        emptyDays(end+1) = struct(...
            fdNames{1}, datetime(prevDay,'ConvertFrom','datenum'), ...
            fdInd, d);
    end
end
emptyDays = emptyDays';

end

function [days, emptyDays] = partitionByDays(data)
%PARTITIONBYDAYS Get input data returned as structure array of the data
%partitioned by days.
%   [days, emptyDays] = partitionByDays(data) Partitions input struct DATA
%   into days using its property TIMESTAMP. DAYS is the partitioned
%   structure array and EMPTYDAYS is an array of datetime values
%   corresponding to the days for which there was no data.

%% Get fieldnames of data
fdNames = fieldnames(data);
f1 = char(fdNames(1));
f2 = char(fdNames(2));
f3 = char(fdNames(3));
f4 = char(fdNames(4));
f5 = char(fdNames(5));
f6 = 'index'; % field to be added to emptyDays

%% Check input for field timestamp as first field
assert(strcmp(f1, 'timestamp'), ...
    'Input struct DATA must have TIMESTAMP as first field')

%% Preallocate size of cell array to return
tnum = datenum(data.timestamp);
nDays = ceil(tnum(end)) - floor(tnum(1));
days = struct(f1,[], f2,[], f3,[], f4,[], f5,[]);

%% Fill return variable with data
currDay = floor(tnum(1));
prevDay = currDay - 1;
nextDay = currDay;
emptyDays = struct(f1,{}, f6,{});
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
        days(d) = struct(...
            f1, data.(f1)(iFirst:iLast), ...
            f2, data.(f2)(iFirst:iLast), ...
            f3, data.(f3)(iFirst:iLast), ...
            f4, data.(f4)(iFirst:iLast), ...
            f5, data.(f5)(iFirst:iLast));
    else
        prevDay = prevDay + 1;
        emptyDays(end+1) = struct(...
            f1, datetime(prevDay,'ConvertFrom','datenum'), ...
            f6, d);
    end
end
emptyDays = emptyDays';

end
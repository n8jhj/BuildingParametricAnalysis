function days = partitionByDays(data)
%PARTITIONBYDAYS Get input data returned as cell array of days of data.
%   days = partitionByDays(data) Partitions input struct DATA into days
%   using its property TIMESTAMP.

%% Preallocate size of cell array to return.
tnum = datenum(data.timestamp);
nDays = tnum(end) - tnum(1);

end
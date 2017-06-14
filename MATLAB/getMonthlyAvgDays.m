function averages = getMonthlyAvgDays(days, emptyDays, varargin)
%GETMONTHLYAVGDAYS Return a struct of days containing the average demand
%profiles for each month of the year.
%   averages = getMonthlyAvgDays(days, emptyDays)
%   Averages the demand values contained in input DAYS for each month and
%   return the result in output AVERAGES. This process makes use of input
%   EMPTYDAYS, a struct containing datetime values corresponding to days in
%   DAYS that are empty. Assumes input DAYS is partitioned by days and each
%   day is split into 1-hour segments, whether all 24 segments exist or
%   not.
%
%   averages = getMonthlyAvgDays(days, emptyDays, nSteps)
%   Averages demand values in DAYS assuming days in DAYS are each split
%   into segments of size 1/NSTEPS days.

%% Initialize return struct
averages = struct('demand', zeros(12,1));

%% Handle input
if ~isempty(varargin)
    nSteps = varargin{1};
else
    nSteps = 24;
end

%% Initialize temporary list of months
months = NaN * zeros(length(days),1);
for i = 1:1:length(months)
    if ~isempty(days(i).timestamp)
        months(i) = month(days(i).timestamp(1));
    end
end

%% Get lists of each month
for i = 1:1:12
    % get average day
    for j = 1:1:nSteps
        for k = 1:1:length(days)
            if month(days(k).timestamp(1)) == i
                append(month, days(k).timestamp(j))
            else
                k = k + 28; % minimum number of days in a month
            end
        end
    end
end

end
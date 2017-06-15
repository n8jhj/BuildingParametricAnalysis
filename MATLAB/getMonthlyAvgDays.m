function averages = getMonthlyAvgDays(days, nSteps, varargin)
%GETMONTHLYAVGDAYS Return a struct of days containing the average demand
%profiles for each month of the year.
%   averages = getMonthlyAvgDays(days,nSteps)
%   Averages the demand values contained in input DAYS for each month and
%   return the result in output AVERAGES. Assumes each day of input DAYS is
%   split into segments of size 1/NSTEPS days.
%
%   averages = getMonthlyAvgDays(days,nSteps,nReqd)
%   Input NREQD is the number of data points required for a given day to be
%   included in averaging. Default is input NSTEPS.

%% Handle input
if ~isempty(varargin)
    nReqd = varargin{1};
else
    nReqd = nSteps;
end

%% Initialize return struct
f1 = 'avgTotFacEn';
f2 = 'avgTotFacDe';
averages = struct(f1,{}, f2,{});

%% Create temporary list of months
months = NaN * zeros(length(days),1);
for i = 1:1:length(months)
    if ~isempty(days(i).timestamp)
        months(i) = month(days(i).timestamp(1));
    end
end

%% Initialize temporary lists of averaged values for one month
avgsAtMonthEn = NaN * zeros(nSteps,1);
avgsAtMonthDe = NaN * zeros(nSteps,1);

%% Get lists of each month
for m = 1:1:12
    % get average day
    for s = 1:1:nSteps
        stepValsEn = [];
        stepValsDe = [];
        lastMonthVal = months(1);
        searchMode = true; % inverse is append mode
        i = 1;
        while i <= length(months)
            % decide whether to be in search or append mode
            if searchMode && months(i) == m
                searchMode = false;
            elseif ~searchMode && months(i)~=m && ~isnan(months(i))
                if ~isnan(lastMonthVal)
                    
                end
                searchMode = true;
            end
            % take action based on mode
            if ~searchMode
                stepValsEn(end+1) = days(i).totFacEn(s);
                stepValsDe(end+1) = days(i).totFacDe(s);
            else
                
            end
            lastMonthVal = months(i);
            i = i + 1;
        end
        avgsAtMonthEn(s) = mean(stepValsEn);
        avgsAtMonthDe(s) = mean(stepValsDe);
    end
    averages(m) = struct(...
        f1, avgsAtMonthEn, ...
        f2, avgsAtMonthDe);
end

end
function averages = getMonthlyAvgDays(days, nSteps, varargin)
%GETMONTHLYAVGDAYS Return a struct of days containing the average demand
%profiles for each month of the year.
%   averages = getMonthlyAvgDays(days,nSteps)
%   Averages the demand values contained in input DAYS for each month and
%   returns the result in output AVERAGES. AVERAGES also includes the
%   number of points used in the average for each month. Assumes each day
%   of input DAYS is split into NSTEPS equal-size segments.
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
fdNames = fieldnames(days);
namesToUseInds = [];
for f = 1:1:length(fdNames)
    if strcmp(fdNames{f}(1:6),'totFac')
        namesToUseInds(end+1) = f;
    end
end
namesToUse = fdNames(namesToUseInds);
nNames = length(namesToUse);
averages = struct([]);
for n = 1:1:nNames
    [averages(:).(namesToUse{n})] = {};
end
fdPts = 'nPts'; % number points that went into the average
[averages(:).(fdPts)] = {};

%% Create temporary list of months
months = NaN(length(days),1);
for i = 1:1:length(months)
    if ~isempty(days(i).timestamp)
        months(i) = month(days(i).timestamp(1));
    end
end

%% Initialize temporary lists of averaged values for one month
avgsAtMonth = NaN(nSteps,nNames);

%% Get and store lists of each month's average day
% for each month
for m = 1:1:12
    % get average day
    for s = 1:1:nSteps
        % get average timestep
        stepVals = NaN(0, nNames); % list of values for current timestep
        np = 0;
        lastMonth = months(1);
        searchMode = true; % inverse is append mode
        boundary = length(months);
        i = 1;
        while i <= boundary
            currMonth = months(i);
            % take action based on mode (search or append)
            if ~searchMode % append
                if currMonth ~= m && ~isnan(currMonth)
                    searchMode = true;
                else
                    [stepVals, np] = ...
                        appendVals(days(i), stepVals, namesToUse, np, ...
                        s, nReqd);
                end
            end
            % searchMode will be reached even if it was just turned on
            if searchMode % search
                if currMonth == m
                    searchMode = false;
                    [stepVals, np] = ...
                        appendVals(days(i), stepVals, namesToUse, np, ...
                        s, nReqd);
                elseif currMonth == lastMonth+1 || ...
                        currMonth == lastMonth-11
                    % you're at the beginning of a month; jump ahead
                    mToGo = mod(12-currMonth+m, 12);
                    jump = 28 + 31*floor(mToGo/2) + 30*(ceil(mToGo/2)-1);
                    i = i + jump - 1; % 1 is added again later
                end
            end
            if i <= boundary
                lastMonth = months(i); % months(i) accounts for jumping
            end
            i = i + 1;
        end
        for n = 1:1:nNames
            avgsAtMonth(s,n) = mean(stepVals(:,n));
        end
    end
    % store results in the return struct
    tempStruct = struct(namesToUse{1}, avgsAtMonth(:,1));
    for n = 2:1:nNames
        tempStruct(:).(namesToUse{n}) = avgsAtMonth(:,n);
    end
    tempStruct(:).(fdPts) = np;
    averages(m) = tempStruct;
end

end

%% Function for appending values to the input struct
function [sv,np] = appendVals(struc,sv,names,np,s,nReqd)

if length(struc.timestamp) >= nReqd
    sv(end+1,1) = struc.(names{1})(s);
    for n = 2:1:length(names)
        sv(end,n) = struc.(names{n})(s);
    end
    np = np + 1;
end

end

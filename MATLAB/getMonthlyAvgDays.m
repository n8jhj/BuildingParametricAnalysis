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
f1 = 'totFacEn';
f2 = 'totFacDe';
f3 = 'nPts'; % number points that went into the average
averages = struct(f1,{}, f2,{}, f3,{});

%% Create temporary list of months
months = NaN(length(days),1);
for i = 1:1:length(months)
    if ~isempty(days(i).timestamp)
        months(i) = month(days(i).timestamp(1));
    end
end

%% Initialize temporary lists of averaged values for one month
avgsAtMonthEn = NaN(nSteps,1);
avgsAtMonthDe = NaN(nSteps,1);


%% Get and store lists of each month's average day
for m = 1:1:12
    % get average day
    for s = 1:1:nSteps
        % get average timestep
        stepValsEn = [];
        stepValsDe = [];
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
                    [stepValsEn, stepValsDe, np] = ...
                        appendVals(days(i), stepValsEn, stepValsDe, ...
                        np, s, nReqd);
                end
            end
            % searchMode will be reached even if it was just turned on
            if searchMode % search
                if currMonth == m
                    searchMode = false;
                    [stepValsEn, stepValsDe, np] = ...
                        appendVals(days(i), stepValsEn, stepValsDe, ...
                        np, s, nReqd);
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
        avgsAtMonthEn(s) = mean(stepValsEn);
        avgsAtMonthDe(s) = mean(stepValsDe);
    end
    % store results in the return struct
    averages(m) = struct(...
        f1, avgsAtMonthEn, ...
        f2, avgsAtMonthDe, ...
        f3, np);
end

end

%% Function for appending
function [sve,svd,np] = appendVals(struc,sve,svd,np,s,nReqd)

if length(struc.timestamp) >= nReqd
    sve(end+1) = struc.totFacEn(s);
    svd(end+1) = struc.totFacDe(s);
    np = np + 1;
end

end

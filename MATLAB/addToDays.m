function days = addToDays(days, field, ptsReqd)
%ADDTODAYS Add input FIELD to days.
%   days = addToDays(days, field, ptsReqd)
%   Adds the specified input FIELD to each day in input struct DAYS and
%   returns it.

%% Add the specified field for each day
% initialize
fdNames = fieldnames(days);
fLen = length(fdNames);
dLen = length(days);
% for each field
for f = 1:1:fLen
    fn = fdNames{f};
    if strcmp(fn(1:6), 'totFac')
        switch field
            case 'tdr'
                tdrVals = getTurndownRatios(days, fn, ptsReqd);
                % for each day
                for d = 1:1:dLen
                    days(d).tdr.(fn) = tdrVals(d);
                end
            case 'nomRng'
                % for each day
                for i = 1:1:dLen
                    if length(days(i).timestamp) >= ptsReqd
                        [days(i).nomRng.rng.(fn), ...
                            days(i).nomRng.vals.(fn)] = ...
                            minPercentRange(days(i).(fn), 0.95);
                    else
                        days(i).nomRng.rng.(fn) = NaN;
                        days(i).nomRng.vals.(fn) = NaN;
                    end
                end
            case 'pkOtlrs'
                
            otherwise
                error('Field %s not recognized', field)
        end
    end
end

end

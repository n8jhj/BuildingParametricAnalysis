function days = addToDays(days, field, ptsReqd)
%ADDTODAYS Add FIELD to DAYS.
%   days = addToDays(days, field, ptsReqd)
%   Adds the specified input FIELD to each day in input struct DAYS and
%   returns it.

%% Initialization
fdNames = fieldnames(days);
fLen = length(fdNames);
dLen = length(days);

%% Add the specified field for each day
% for each field
for f = 1:1:fLen
    fn = fdNames{f};
    if length(fn) < 6 || ~strcmp(fn(1:6), 'totFac')
        % move to next field is this one doesn't pass the check
        continue
    end
    % for each day
    for d = 1:1:dLen
        try
            % add specified field
            days = addField(days,d,field,fn,ptsReqd);
        catch ME
            fprintf('Error at day %i\n', d)
            rethrow(ME)
        end
    end
end

end


%% Perform addition of specified field to days
function days = addField(days,d,field,fn,ptsReqd)
switch field
    case 'tdr'
        if length(days(d).timestamp) >= ptsReqd
            days(d).tdr.(fn) = turndownRatio(days(d).(fn));
        else
            days(d).tdr.(fn) = NaN;
        end
    case 'nomRng'
        if length(days(d).timestamp) >= ptsReqd
            [days(d).nomRng.rng.(fn), ...
                days(d).nomRng.vals.(fn)] = ...
                minPercentRange(days(d).(fn), 0.95);
        else
            days(d).nomRng.rng.(fn) = NaN;
            days(d).nomRng.vals.(fn) = NaN;
        end
    case 'pkOtlrs'
        if ~isnan(days(d).nomRng.vals.(fn))
            days(d).pkOtlrs.(fn) = ...
                peakOutliers(days(d).(fn),...
                days(d).nomRng.vals.(fn));
        else
            days(d).pkOtlrs.(fn) = NaN;
        end
    case 'cumDem'
        if length(days(d).timestamp) >= ptsReqd
            days(d).cumDem.(fn) = ...
                cumulativeDemand(days(d).(fn));
        end
    otherwise
        error('Field %s not recognized', field)
end
end

function days = addToDays(days, field, ptsReqd)
%ADDTODAYS Add input FIELD to days.
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
    if length(fn) >= 6 && strcmp(fn(1:6), 'totFac')
        % for each day
        for d = 1:1:dLen
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
                    % pass (for now)
                otherwise
                    error('Field %s not recognized', field)
            end
        end
    end
end

end

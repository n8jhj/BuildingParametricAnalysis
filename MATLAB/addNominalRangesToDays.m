function days = addNominalRangesToDays(days, ptsReqd)
%ADDNOMINALRANGESTODAYS Add nominal ranges to each day in input DAYS for
%the input FIELD specified.
%   days = addNominalRangesToDays(days, ptsReqd)
%   Returns struct DAYS with new field 'nomRng' added. Subfields
%   corresponding to the types of data contained in DAYS are in turn added
%   to days.nomRng.

%% Get nominal ranges for each day
% initialize
fdNames = fieldnames(days);
fLen = length(fdNames);
dLen = length(days);
% for each field
for f = 1:1:fLen
    fn = fdNames{f};
    if strcmp(fn(1:6), 'totFac')
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
    end
end


end

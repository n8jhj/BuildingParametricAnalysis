function days = addNominalRangesToDays(days, field, ptsReqd)
%ADDNOMINALRANGESTODAYS Add nominal ranges field to each day.
%   days = addNominalRangesToDays(days, field, ptsReqd)
%   Returns DAYS with a subfield FIELD of 'nomRng' added.

%% Get nominal ranges for each day
% initialize
dLen = length(days);
% for each day
for i = 1:1:dLen
    if length(days(i).timestamp) >= ptsReqd
        [days(i).nomRng.rng.(field), days(i).nomRng.vals.(field)] = ...
            minPercentRange(days(i).(field), 0.95);
    else
        days(i).nomRng.rng.(field) = NaN;
        days(i).nomRng.vals.(field) = NaN;
    end
end

end

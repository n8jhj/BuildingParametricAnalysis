function tdrs = getTurndownRatios(days, field, ptsReqd)
%GETTURNDOWNRATIOS List containing the turndown ratio for each day.
%   tdrs = getTurndownRatios(days, field, ptsReqd)
%   Returns list of TDRs for the field FIELD in each day of DAYS that has
%   at least PTSREQD data points.

%% Get turndown ratios for each day
tdrs = NaN(length(days), 1);
for i = 1:1:length(days)
    if length(days(i).timestamp) >= ptsReqd
        tdrs(i) = turndownRatio(days(i).(field));
    end
end

end
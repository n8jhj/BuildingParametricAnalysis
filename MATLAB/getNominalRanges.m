function nmrs = getNominalRanges(days, field, ptsReqd)
%GETNOMINALRANGES List containing the nominal range for each day.
%   nmrs = getTurndownRatios(days, field, ptsReqd)
%   Returns list of TDRs for the field FIELD in each day of DAYS that has
%   at least PTSREQD data points.

%% Get nominal ranges for each day
% initialize
nmrs = NaN(length(days), 1);
dLen = length(days);
% for each day
for i = 1:1:dLen
    if length(days(i).timestamp) >= ptsReqd
        [nmrs(i),~] = minPercentRange(days(i).(field), 0.95);
    end
end

end

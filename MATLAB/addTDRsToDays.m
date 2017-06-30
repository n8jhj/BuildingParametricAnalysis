function days = addTDRsToDays(days, ptsReqd)
%ADDTDRSTODAYS Add the turndown ratio as a field for each day.
%   days = addTDRsToDays(days)
%   Returns struct DAYS with new fields 'tdrEn' and 'tdrDe' added.

%% Add turndown ratios for each day
fdNames = fieldnames(days);
fLen = length(fdNames);
dLen = length(days);
for f = 1:1:fLen
    fn = fdNames{f};
    if strcmp(fn(1:6),'totFac')
        tdrVals = getTurndownRatios(days, fn, ptsReqd);
        % for each day
        for d = 1:1:dLen
            if isfield(days, 'tdr')
                days.tdr.(fn) = tdrVals(d);
            else
                days.tdr = struct(fn, tdrVals(d));
            end
        end
    end
end

end
function days = addTDRsToDays(days, ptsReqd)
%ADDTDRSTODAYS Add the turndown ratio as a field for each day.
%   days = addTDRsToDays(days, ptsReqd)
%   Returns struct DAYS with new field 'tdr' added. Subfields corresponding
%   to the types of data contained in DAYS are in turn added to days.tdr.

%% Add turndown ratios for each day
% initialize
fdNames = fieldnames(days);
fLen = length(fdNames);
dLen = length(days);
% for each field
for f = 1:1:fLen
    fn = fdNames{f};
    if strcmp(fn(1:6),'totFac')
        tdrVals = getTurndownRatios(days, fn, ptsReqd);
        % for each day
        for d = 1:1:dLen
            days(d).tdr.(fn) = tdrVals(d);
        end
    end
end

end

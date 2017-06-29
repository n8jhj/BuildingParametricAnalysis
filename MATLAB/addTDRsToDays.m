function days = addTDRsToDays(days, ptsReqd)
%ADDTDRSTODAYS Add the turndown ratio as a field for each day.
%   days = addTDRsToDays(days)
%   Returns struct DAYS with new fields 'tdrEn' and 'tdrDe' added.

%% Add turndown ratios for each day
fdNames = fieldnames(days);
for i = 2:1:length(fdNames) % omit first field: timestamp
    tdrVals = num2cell(getTurndownRatios(days, fdNames{i}, ptsReqd));
    tdrName = strcat('tdr_',fdNames{i});
    [days.(tdrName)] = tdrVals{:};
end

end
function days = addTDRsToDays(days)
%ADDTDRSTODAYS Add the turndown ratio as a field for each day.
%   days = addTDRsToDays(days)
%   Returns struct DAYS with new fields 'tdrEn' and 'tdrDe' added.

%% Add turndown ratios for each day
ptsReqd = 24; % only days with a complete set of data will have a TDR
tdrEn = num2cell(getTurndownRatios(days, 'totFacEn', ptsReqd));
tdrDe = num2cell(getTurndownRatios(days, 'totFacDe', ptsReqd));
[days.tdrEn] = tdrEn{:};
[days.tdrDe] = tdrDe{:};

end
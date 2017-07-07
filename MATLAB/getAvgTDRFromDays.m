function avgTdr = getAvgTDRFromDays(days)
%GETAVGTDRFROMDAYS Average turndown ratio, extracted from struct DAYS.
%   avgTdr = getAvgTDRFromDays(days)
%   Takes mean of all turndown ratios for each subfield in field 'tdr'
%   within input struct DAYS. Returns structure avgTdr with same subfields
%   as 'tdr'.

%% Get field names within field 'tdr'
fdNames = fieldNamesWithinField(days,{'tdr'});
fLen = length(fdNames);

%% Store TDRs in list
dLen = length(days);
% for each field
for f = 1:1:fLen
    fn = fdNames{f};
    tdrs = NaN(dLen,1);
    % for each day
    for d = 1:1:dLen
        % get TDRs
        tdrs(d) = days(d).tdr.(fn);
    end
    % get rid of any Inf values
    tdrs(isinf(tdrs)) = NaN;
    % take mean of TDRs
    tdrMean = nanmean(tdrs);
    % store in return struct
    if f == 1
        avgTdr = struct(fn, tdrMean);
    else
        avgTdr.(fn) = tdrMean;
    end
end

end

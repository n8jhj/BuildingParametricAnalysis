function avgNomRng = getAvgNomRngFromDays(days)
%GETAVGNOMRNGFROMDAYS Average nominal range.
%   avgNomRng = getAvgNomRngFromDays(days)
%   Takes mean of all nominal ranges for each subfield in field
%   'nomRng.rng' within input struct DAYS. Returns structure avgNomRng with
%   same subfields as 'nomRng.rng'.

%% Get field names within 'nomRng.rng'
fdNames = fieldNamesWithinField(days,{'nomRng','rng'});
fLen = length(fdNames);

%% Store nominal ranges in list
dLen = length(days);
% for each field
for f = 1:1:fLen
    fn = fdNames{f};
    nomRngs = NaN(dLen,1);
    % for each day
    for d = 1:1:dLen
        % get nominal ranges
        nomRngs(d) = days(d).nomRng.rng.(fn);
    end
    % take mean of nominal ranges
    nomRngMean = nanmean(nomRngs);
    % store in return struct
    if f == 1
        avgNomRng = struct(fn, nomRngMean);
    else
        avgNomRng.(fn) = nomRngMean;
    end
end

end

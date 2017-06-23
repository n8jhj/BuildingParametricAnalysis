function avgDay = getAvgDayFromADs(ads)
%GETAVGDAYFROMADS Return the average day from a list of average days.
%   avgDay = getAvgDayFromADs(ads)
%   Utilizes data about each average day and the number of points used to
%   calculate each average day to calculate the overall average day.

%% Get fieldnames of each average day
fdNames = fieldnames(ads(1));

%% Check for existence of field 'nPts'
assert(strcmp(fdNames{end}, 'nPts'), ...
    'Input should contain field ''nPts'' as the last field')

%% For each field, calculate the average
nPts = [ads.nPts].';
for i = 1:1:length(fdNames)-1 % last field is nPts
    field = [ads.(fdNames{i})].';
    sz = size(field);
    fieldAvg = NaN(sz(2),1);
    for j = 1:1:sz(2) % for each timestep
        % get mean of all data points
        fieldAvg(j) = weightedMean(field(:,j),nPts);
    end
    avgDay.(fdNames{i}) = fieldAvg;
end

end


function wmean = weightedMean(vals,wts)

wLen = length(wts);
assert(length(vals) == wLen, 'vals and wts must be of same length')
sumw = sum(wts);
wmean = 0;
for i = 1:1:wLen
    wmean = wmean + vals(i) * (wts(i) / sumw);
end

end

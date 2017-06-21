function [mpr, filtDat, outliers] = minPercentRange(data, pBounds)
%MINPERCENTRANGE Input percent of data points that will result in lowest
%range.
%   [mpr, filtDat] = minPercentRange(data, pBounds)
%   Finds the minimum possible range MPR and the set of values
%   corresponding to that range FILTDAT that contains PBOUNDS percent of
%   input DATA. DATA should be a list. PBOUNDS should be a decimal value,
%   not a percent value. Values from DATA that are omitted are stored in
%   FILTDAT as NaN. If there are more NaN values in DATA than are required
%   to create a list that is PBOUNDS percent the size of DATA, no more NaN
%   values will be added in FILTDAT.

%% Check input
sz = size(data);
row = false;
if sz(1) == 1
    row = true;
    data = data';
else
    assert(sz(2)==1, 'Input data must be array; not matrix')
end

%% Initialize function variables
dLen = length(data);

%% Find number of values that should be missing in the return
nMisg = round((1-pBounds) * dLen);

%% Check for NaNs in input and find out how many values to remove
nRmv = nMisg - sum(isnan(data));
if nRmv < 1
    if row
        data = data';
    end
    filtDat = data;
    return
end

%% Sort input numerically
[sorted,ind] = sort(data);

%% Find minimum range
% Assuming nRmv is small; otherwise, this will take a long time
cMin = 0;
minR = range(sorted(1 : end-nRmv));
for c = 1:1:nRmv % zero-indexing, omit the first (nCombinations = nRmv+1)
    newR = range(sorted(1+c : end-nRmv+c));
    if newR < minR
        minR = newR;
        cMin = c;
    end
end

%% Convert proper indices of data to NaN
indNan = [ind(1 : cMin); ind(end-nRmv+cMin+1 : end)];
for i = 1:1:length(indNan)
    data(indNan(i)) = NaN;
end

%% Return mpr and data with minimum percent range
mpr = minR;
if row
    filtDat = data';    
else
    filtDat = data;
end

end

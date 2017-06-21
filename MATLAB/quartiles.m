function [q1, q2, q3, outliers] = quartiles(data)
%QUARTILES Values of each quartile (25%, 50%, 75%).
%   [q1, q2, q3, ~] = quartiles(data)
%   Returns 1st, 2nd (median), and 3rd quartiles of input DATA.
%
%   [~, ~, ~, outliers] = quartiles(data)
%   Returns a struct OUTLIERS that contains index-value pairs of the
%   outliers in DATA. OUTLIERS is indexed by how many "fences" past the IQR
%   the group of outliers at that index is. A fence is 1.5 times the IQR.

%% Sort input data
[sorted,sortInd] = sort(data);

%% Find quartile indices
dLen = length(sorted);
ind2 = (dLen+1) / 2;
ind1 = ceil(ind2) / 2;
ind3 = dLen - ind1 + 1;

%% Calculate quartiles
q1 = (sorted(floor(ind1)) + sorted(ceil(ind1))) / 2;
q2 = (sorted(floor(ind2)) + sorted(ceil(ind2))) / 2;
q3 = (sorted(floor(ind3)) + sorted(ceil(ind3))) / 2;

%% Get outliers
f1 = 'fenceGrpLo';
f2 = 'fenceGrpHi';
outliers = struct(f1,{}, f2,{});
% get max fence outliers are past
iqr = q3 - q1;
fence = 1.5 * iqr;
maxFence = floor((max(data) - q3) / fence);
% sort outliers into their respective fence groups
for i = 1:1:maxFence
    fIndsLo = (sorted < q1 - fence*i) .* (sorted > q1 - fence*(i+1));
    fIndsHi = (sorted > q3 + fence*i) .* (sorted < q3 + fence*(i+1));
    fgLo = [sortInd(logical(fIndsLo)), sorted(logical(fIndsLo))];
    fgHi = [sortInd(logical(fIndsHi)), sorted(logical(fIndsHi))];
    outliers(i) = struct(...
        f1, fgLo, ...
        f2, fgHi);
end

end
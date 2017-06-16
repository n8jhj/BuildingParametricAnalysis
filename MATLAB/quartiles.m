function [q1, q2, q3] = quartiles(data)
%QUARTILES Values of each quartile (25%, 50%, 75%).
%   [q1, q2, q3] = quartiles(data)
%   Returns 1st, 2nd (median), and 3rd quartiles of input DATA.

%% Sort input data
sorted = sort(data);

%% Find quartile indices
dLen = length(sorted);
ind2 = (dLen+1) / 2;
ind1 = ceil(ind2) / 2;
ind3 = dLen - ind1 + 1;

%% Calculate quartiles
q1 = (sorted(floor(ind1)) + sorted(ceil(ind1))) / 2;
q2 = (sorted(floor(ind2)) + sorted(ceil(ind2))) / 2;
q3 = (sorted(floor(ind3)) + sorted(ceil(ind3))) / 2;

end
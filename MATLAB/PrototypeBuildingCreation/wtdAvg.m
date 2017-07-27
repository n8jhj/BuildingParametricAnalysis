function w_avg = wtdAvg(vals,wts)
%WTDAVG Weighted average of input values by input weights.
%   w_avg = wtdAvg(vals,wts)
%   VALS is a list of values and WTS is a list of weights, each element
%   corresponding with the element at the same index in VALS.

%% Check input
assert(length(vals)==length(wts), ...
    '''wts'' and ''vals'' must be same length.')

%% Calculate weighted average
w_total = sum(wts);
w_avg = 0;
for i = 1:1:length(vals)
    w_avg = w_avg + vals(i) * (wts(i)/w_total);
end

end

function w_avg = weightedAvg(bldgType,avg_param,wt_param)
%WEIGHTEDAVG Weighted average of a given parameter of a given building
%type.
%   w_avg = weightedAvg(bldgType,param)
%   Returns weighted average of parameter PARAM for the building type
%   BLDGTYPE of the DOE prototype buildings.

%% Get values to be averaged and weights
[weights,~] = paramData(bldgType,wt_param);
[values,~] = paramData(bldgType,avg_param);

%% Check that weights and values have same number of elements
sz_w = size(weights);
sz_v = size(values);
assert(sz_w(1) == sz_v(1), ...
    '''weights'' and ''values'' must be of same length.')

%% Calculate weighted average
w_total = sum([weights{:,2}]);
w_avg = 0;
for i = 1:1:length(values)
    w_avg = w_avg + values{i,2} * (weights{i,2}/w_total);
end

end

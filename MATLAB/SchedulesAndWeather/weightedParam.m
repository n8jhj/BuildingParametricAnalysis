function w_par = weightedParam(bldgType,avg_param,wt_param)
%WEIGHTEDPARAM Weighted average of a given parameter of a given building
%type.
%   w_par = weightedParam(bldgType,avg_param,wt_param)
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
w_par = wtdAvg(values{:,2},weights{:,2});

end

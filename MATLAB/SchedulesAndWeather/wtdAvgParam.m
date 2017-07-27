function wa_par = wtdAvgParam(bldgType,avg_param,wt_param)
%WTDAVGPARAM Weighted average of a given parameter of a given building
%type.
%   wa_par = wtdAvgParam(bldgType,avg_param,wt_param)
%   Returns weighted average of parameter PARAM for the building type
%   BLDGTYPE of the DOE prototype buildings.

%% Get values to be averaged and weights
[weights,~] = spaceParameters(bldgType,wt_param);
[values,~] = spaceParameters(bldgType,avg_param);

%% Check that weights and values have same number of elements
sz_w = size(weights);
sz_v = size(values);
assert(sz_w(1) == sz_v(1), ...
    '''weights'' and ''values'' must be of same length.')

%% Calculate weighted average
wa_par = wtdAvg(values{:,2},weights{:,2});

end

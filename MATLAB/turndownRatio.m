function tdr = turndownRatio(data)
%TURNDOWNRATIO Calculate turndown ratio of input DATA.
%   tdr = turndownRatio(data)
%   TDR is calculated as (max value) / (min value) of DATA. Input DATA must
%   be a list of raw values.

maxVal = max(data);
minVal = min(data);
tdr = maxVal / minVal;

end

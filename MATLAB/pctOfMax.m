function percentages = pctOfMax(data)
%PCTOFMAX Convert input data to percentages of the maximum value (including
%outliers).
%   percentages = pctOfMax(data)
%   DATA is an array of data values. PERCENTAGES is an array of values
%   between 0 and 1.

maxVal = max(data);
percentages = data ./ maxVal;

end
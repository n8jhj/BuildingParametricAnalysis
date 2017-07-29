function plotDiff(rows,cols,figNumMin,figNumSub)
%PLOTDIFF Plot difference in axes at specified position(s) of subplots.
%   plotDiff(rows,cols,pos,figNumMin,figNumSub)
%   Plot data from figure(FIGNUMMIN) is minuend (subtracted from); plot
%   data from figure(FIGNUMSUB) is subtrahend (to be subtracted). FIGNUMMIN
%   and FIGNUMSUB may each be either a single integer or a list of
%   integers.

%% Get plots data
[x,y] = comparisonPlots(rows,cols);

%% Get minuend data
if ~isempty(figNumMin)
    y_min = y{figNumMin(1)};
    for i = 2:1:length(figNumMin)
        y_min = y_min + y{figNumMin(i)};
    end
else
    y_min = zeros(1,length(x{1}));
end

%% Get subtrahend data
if ~isempty(figNumSub)
    y_sub = y{figNumSub(1)};
    for i = 2:1:length(figNumSub)
        y_sub = y_sub + y{figNumSub(i)};
    end
else
    y_sub = zeros(1,length(x{1}));
end

%% Plot
figure
plot(x{1},y_min-y_sub)

end

function plotDiff(rows,cols,posRow,figNumMin,figNumSub,varargin)
%PLOTDIFF Plot difference in axes at specified position of subplots.
%   plotDiff(rows,cols,pos,figNumMin,figNumSub)
%   Plot data from figure(FIGNUMMIN) is minuend (subtracted from); plot
%   data from figure(FIGNUMSUB) is subtrahend (to be subtracted).

%% Handle input
if ~isempty(varargin)
    combine = varargin{1};
else
    combine = false;
end

%% Get data from fig minuend
figure(figNumMin)
subplot(rows,cols,posRow*2-1)
h = findobj(gca,'Type','line');
x = h.XData;
y1 = h.YData;

%% Get data from fig subtrahend
figure(figNumSub)
subplot(rows,cols,posRow*2)
h = findobj(gca,'Type','line');
y2 = h.YData;

%% Plot
figure
plot(x,y1-y2)
if combine
    hold on
    plot(x,y1, x,y2)
    hold off
    legend({'Difference','Minuend','Subtrahend'})
end

end

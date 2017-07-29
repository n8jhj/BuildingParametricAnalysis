function [x,y] = comparisonPlots(r,c)
%COMPARISONPLOTS Axes data from plots in a subplot.

n_plots = r*c;
x = cell(n_plots,1);
y = cell(n_plots,1);
for i = 1:1:n_plots
    subplot(r,c,i)
    h = findobj(gca,'Type','line');
    if ~isa(h,'matlab.graphics.GraphicsPlaceholder')
        x{i} = h.XData;
        y{i} = h.YData;
    end
end

end

function plotDemandsTogether(buildings, save)
%PLOTDEMANDSTOGETHER Plot of key demand graphs on one figure.
%   plotDemandsTogether(buildings, save)
%   BUILDINGS is the building for which data will be plotted. SAVE is an
%   optional boolean argument specifying whether the figure should be
%   saved. Default is false.

%% Handle input
if nargin < 2
    save = false;
end

%% For each building, plot, resize, and optionally save
for i = 1:1:length(buildings)
    building = buildings(i);
    
    % Plot
    fig = figure;
    subplot(2,2,1)
    plotDemand(building,'nofig','totFacEn');
    subplot(2,2,2)
    plotDemand(building,'nofig','totFacDe');
    subplot(2,2,3)
    plotDemandHistogram(building,'nofig','totFacEn')
    subplot(2,2,4)
    plotDemandHistogram(building,'nofig','totFacDe')

    % Resize
    resizeFigure(fig)

    % Save
    if save
        saveas(fig, strcat(building.name, '_demandPlots.png'))
    end
end

end


%% Resize figure
function resizeFigure(fig)
figPos = get(fig,'OuterPosition');
deltaW = 500;
deltaH = 300;
figPos(2) = figPos(2) - deltaH;
figPos(3) = figPos(3) + deltaW;
figPos(4) = figPos(4) + deltaH;
set(fig,'OuterPosition',figPos)
end

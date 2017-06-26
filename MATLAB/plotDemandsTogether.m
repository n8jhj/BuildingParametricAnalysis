function plotDemandsTogether(building, save)
%PLOTDEMANDSTOGETHER Plot of key demand graphs on one figure.
%   plotDemandsTogether(building, save)
%   BUILDING is the building for which data will be plotted. SAVE is an
%   optional boolean argument specifying whether the figure should be
%   saved. Default is false.

%% Plot
subplot(2,2,1)
plotDemand(building,'nofig','totFacEn');
subplot(2,2,2)
plotDemand(building,'nofig','totFacDe');
subplot(2,2,3)
plotDemandHistogram(building,'nofig','totFacEn')
subplot(2,2,4)
plotDemandHistogram(building,'nofig','totFacDe')

%% Resize
fig = gcf;
figPos = get(fig,'OuterPosition');
deltaW = 500;
deltaH = 300;
figPos(2) = figPos(2) - deltaH;
figPos(3) = figPos(3) + deltaW;
figPos(4) = figPos(4) + deltaH;
set(fig,'OuterPosition',figPos)

%% Save
if nargin < 2
    save = false;
end
if save
    saveas(fig, strcat(building.name, '_demandPlots.png'))
end

end

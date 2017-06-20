function histogramDemand(building)
%HISTOGRAMDEMAND Histogram of building data by percentage of maximum
%demand.
%   histogramDemand(building)
%   Plots histogram of BUILDING using automatically determined bin sizes.
%   BUILDING should be a struct with fields 'name' and 'data'.

%% Get percent-ized data
pctsEn = 100 * pctOfMax(building.data.totFacEn);
pctsDe = 100 * pctOfMax(building.data.totFacDe);

%% Plot histograms
close all
bName = building.name;

fig1 = figure;
histogram(pctsEn)
title(strcat(bName, ' Total Facility Energy Demand by Percent of Maximum'))

fig2 = figure;
histogram(pctsDe)
title(strcat(bName, ' Total Facility Power Demand by Percent of Maximum'))

%% Clean up positioning of figures for better visibility
positionFigures(fig1, fig2)

end
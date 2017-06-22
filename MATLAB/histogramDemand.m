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
title({bName, 'Total Facility Energy Demand by Percent of Maximum'})
xlabel('Percent of Maximum Overall Value (%)')
ylabel('Number of Data Points')

fig2 = figure;
histogram(pctsDe)
title({bName, 'Total Facility Power Demand by Percent of Maximum'})
xlabel('Percent of Maximum Overall Value (%)')
ylabel('Number of Data Points')

%% Clean up positioning of figures for better visibility
positionFigures(fig1, fig2)

end
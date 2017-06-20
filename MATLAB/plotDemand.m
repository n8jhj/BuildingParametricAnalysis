function dataStruct = plotDemand(building)
%PLOTDEMAND View energy and power demand profiles.
%   dataStruct = plotDemand(building)
%   Plots energy and power demand profiles for input BUILDING. BUILDING may
%   be either a string of the file name or a struct containing the name and
%   data of a building. Returns the data struct of BUILDING.

%% Get data
if isa(building, 'char')
    dataStruct = NYSERDA_importToStruct(building);
    bName = erase(building, '.csv');
elseif isa(building, 'struct')
    dataStruct = building.data;
    bName = building.name;
else
    error('Input should be either a .csv file name or a struct of data')
end

%% Plot
close all

fig1 = figure;
plot(dataStruct.timestamp, dataStruct.totFacEn)
title(strcat(bName, ' Total Facility Energy Demand'))

fig2 = figure;
plot(dataStruct.timestamp, dataStruct.totFacDe)
title(strcat(bName, ' Total Facility Power Demand'))

%% Clean up positioning of figures for better visibility
positionFigures(fig1, fig2)

end
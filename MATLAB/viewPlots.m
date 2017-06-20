function dataStruct = viewPlots(dataFile)
%VIEWPLOTS View energy and power demand profiles.

%% Get data
dataStruct = NYSERDA_importToStruct(dataFile);

%% Plot
close all

fig1 = figure(1);
plot(dataStruct.totFacEn)
title(strcat(dataFile, 'Total Facility Energy Demand'))
fig1Pos = get(fig1, 'OuterPosition');
deltaX = fig1Pos(3)/2;
fig1Pos(1) = fig1Pos(1) + deltaX + 10;
set(fig1, 'OuterPosition', fig1Pos)

fig2 = figure(2);
plot(dataStruct.totFacDe)
title(strcat(dataFile, 'Total Facility Power Demand'))
fig2Pos = get(fig2, 'OuterPosition');
deltaY = fig2Pos(4) + 10;
fig2Pos(1) = fig2Pos(1) + deltaX + 10;
fig2Pos(2) = fig2Pos(2) - deltaY;
set(fig2, 'OuterPosition', fig2Pos)

end
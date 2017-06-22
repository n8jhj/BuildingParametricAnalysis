function buildingDaysBoxplots(buildings, fieldname)
%BUILDINGBOXPLOTS Boxplots of a certain field of input buildings.
%   buildingBoxplots(buildings, fieldname)
%   Creates boxplots displaying field specified by FIELDNAME for each
%   building in the set BUILDINGS, all on the same plot axes. FIELDNAME is
%   assumed to be within building.days.
%
% Example:
%   buildingBoxplots(buildings, 'tdrEn')
%   Creates boxplots of days.tdrEn for each building in BUILDINGS.

%% Create boxplot-compatible data structure
% get maximum length of input field 'param'
bLen = length(buildings);
xLen = 0;
for b = 1:1:bLen
    xLen = xLen + length(buildings(b).days);
end
x = zeros(xLen,1);
g = cell(xLen,1);
ind = 0;
for b = 1:1:bLen
    field = [buildings(b).days.(fieldname)].';
    fLen = length(field);
    x(ind+1:ind+fLen) = field;
    names = cell(fLen,1);
    names(1:fLen) = cellstr(buildings(b).name);
    g(ind+1:ind+fLen) = names.';
    ind = ind + fLen;
end

%% Create boxplot
% close all
fig1 = figure;
boxplot(x,g,'PlotStyle','compact');
figPos = get(fig1, 'Position');
deltaY = 1000;
figPos(4) = figPos(4) + deltaY;
figPos(2) = figPos(2) - deltaY;
set(fig1, 'Position', figPos);

end
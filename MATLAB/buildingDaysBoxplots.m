function buildingDaysBoxplots(buildings, fieldname)
%BUILDINGDAYSBOXPLOTS Boxplots of a certain field of input buildings.
%   buildingBoxplots(buildings, fieldname)
%   Creates boxplots displaying field specified by FIELDNAME for each
%   building in the set BUILDINGS, all on the same plot axes. FIELDNAME is
%   assumed to be within building.days. Input BUILDINGS can be either a
%   struct containing a set of buildings or a cell array containing
%   multiple struct sets of buildings. In the case of multiple sets, each
%   set is assigned a different color in the boxplot.
%
% Example:
%   buildingBoxplots(buildings, 'tdr_totFacEn')
%   If buildings is not a cell array of structs, this creates boxplots of
%   days.tdr_totFacEn for each building in BUILDINGS.


%% Handle input
if ~iscell(buildings)
    buildings = {buildings};
end

%% Create one combined struct for boxplot compatibility
% colors preset: blu, mrn, red, grn, cyn, blk, ylw
cp = 'bmrgcky';
colors = 'b';
% set field names of combined struct
f1 = 'name';
f2 = 'data';
f3 = 'set';
% initialize combined struct
combStruct = struct(...
    f1, {buildings{1}(1).(f1)}, ...
    f2, {buildings{1}(1).days.(fieldname)}, ...
    f3, 1);
% for each set of buildings
bStart = 2;
iEnd = length(buildings{1}(1).days);
for set = 1:1:length(buildings)
    % add each building in the set to combined struct
    for b = bStart:1:length(buildings{set})
        iStart = iEnd + 1;
        iEnd = iStart + length(buildings{set}(b).days) - 1;
        % set up cell arrays to assign
        f1Cell = cell(iEnd-iStart+1, 1);
        f2Cell = f1Cell;
        f3Cell = f1Cell;
        f1Cell(:) = {buildings{set}(b).(f1)};
        f2Cell(:) = {buildings{set}(b).days.(fieldname)};
        f3Cell(:) = {set};
        % assign cell arrays to combined struct
        [combStruct(iStart:iEnd).(f1)] = f1Cell{:};
        [combStruct(iStart:iEnd).(f2)] = f2Cell{:};
        [combStruct(iStart:iEnd).(f3)] = f3Cell{:};
        % update colors array
        colors(end+1) = cp(set);
    end
    bStart = 1;
end

%% Create boxplot
% plot
x = [combStruct.(f2)];
g = {combStruct.(f1)};
fig = figure;
boxplot(x,g, 'PlotStyle','compact', 'Colors',colors);
% resize
resizeFigure(fig)

end


function resizeFigure(fig)
figPos = get(fig, 'Position');
deltaY = 1000;
figPos(4) = figPos(4) + deltaY;
figPos(2) = figPos(2) - deltaY;
set(fig, 'Position', figPos);
end

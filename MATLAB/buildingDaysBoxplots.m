function buildingDaysBoxplots(buildings, fieldname)
%BUILDINGDAYSBOXPLOTS Boxplots of a certain field of input buildings.
%   buildingBoxplots(buildings, fieldname)
%   Creates boxplots displaying field specified by FIELDNAME for each
%   building in the set BUILDINGS, all on the same plot axes. FIELDNAME is
%   assumed to be within building.days and should be specified as a path
%   given as a cell array of strings. Input BUILDINGS can be either a
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

%% Colors preset: blu, mrn, red, grn, cyn, blk, ylw
cp = 'bmrgcky';
% initialize colors
colors = 'b';

%% Create combined lists for boxplot compatibility
% initialize combined list
% col 1 -> building names
% col 2 -> building data
lenTotal = 0;
for set = 1:1:length(buildings)
    for b = 1:1:length(buildings{set})
        lenTotal = lenTotal + length(buildings{set}(b).days);
    end
end
combList = cell(lenTotal, 2);
% for each set of buildings
iEnd = 0;
for set = 1:1:length(buildings)
    % add each building in the set to combined struct
    for b = 1:1:length(buildings{set})
        iStart = iEnd + 1;
        iEnd = iStart + length(buildings{set}(b).days) - 1;
        % assign values to combined lists
        combList(iStart:iEnd, 1) = {buildings{set}(b).name};
        for d = 1:1:length(buildings{set}(b).days)
            % add value to field 2 cell array
            combList(iStart-1+d, 2) = ...
                {getFieldByPath(buildings{set}(b), ['days',d,fieldname])};
        end
        % update colors array
        colors(end+1) = cp(set);
    end
end

%% Create boxplot
% plot
x = cell2mat(combList(:,2));
g = combList(:,1);
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

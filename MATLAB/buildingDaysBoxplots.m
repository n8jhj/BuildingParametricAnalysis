function buildingDaysBoxplots(buildings, fieldname, varargin)
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
%   buildingBoxplots(buildings, fieldname, warnings)
%   Input WARNINGS is an optional boolean input, specifying whether
%   warnings should be displayed at all for this function. Default is true,
%   meaning warnings will be displayed.
%
% Example:
%   buildingBoxplots(buildings,{'tdr','totFacEn'})
%   If buildings is not a cell array of structs, this creates boxplots of
%   days.tdr.totFacEn for each building in BUILDINGS.


%% Handle input
% check for cell array buildings input
if ~iscell(buildings)
    buildings = {buildings};
end
% check for optional input warnings
if ~isempty(varargin)
    warn = warning;
    warnState = warn.state;
    if varargin{1}
        warning('on','all')
    else
        warning('off','all')
    end
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
            % add value to cell array col 2
            combList = ...
                addDataValue(combList, buildings{set}(b), iStart, d, ...
                fieldname);
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

%% Reset state of warnings
if ~isempty(varargin{1})
    warning(warnState,'all')
end

end


%% Add data value to combined list
function combList = addDataValue(combList,bldg,iStart,d,fn)
try
    combList(iStart-1+d, 2) = ...
        {getFieldByPath(bldg, ['days',d,fn])};
catch ME
    switch ME.identifier
        case 'MATLAB:badsubscript'
            warning(strcat('Bad subscript at building %s, day %i.', ...
                ' Assigning value of NaN.'), bldg.name, d);
            combList(iStart-1+d, 2) = {NaN};
        otherwise
            rethrow(ME)
    end
end
end


%% Resize boxplot figure to look better
function resizeFigure(fig)
figPos = get(fig, 'Position');
deltaY = 1000;
figPos(4) = figPos(4) + deltaY;
figPos(2) = figPos(2) - deltaY;
set(fig, 'Position', figPos);
end

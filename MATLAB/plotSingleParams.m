function plotSingleParams(buildings, x_field, y_field, varargin)
%PLOTSINGLEPARAMS Plot a given two parameters of all input buildings.
%BUILDINGS may be either a struct of buildings or a cell array containing
%structs of building sets.
%   plotSingleParams(buildings, x_field, y_field)
%   Plot the fields of buildings given by X_FIELD and Y_FIELD as a function
%   of size. X_FIELD and Y_FIELD are cell arrays containing string-index
%   sets that supply the path to the desired fields. First value must be a
%   string for both X_FIELD and Y_FIELD.
%
%   plotAgainstSize(buildings, x_field, y_field, 'Colors', colors)
%   Option 'Colors' with input COLORS as a character array denoting the
%   color assigned to each set of buildings.
%
% Example:
%   plotAgainstSize(buildings, {'omean',1,'totFacEn'}, {'avgTdr',1,'totFacEn'}, 'Colors', 'bmr')

%% Discern input type
if ~iscell(buildings)
    buildings = {buildings};
end
nSets = length(buildings);

%% Colors preset
cp = 'bmrgcky';

%% Set up plottable cell arrays
% initialize
x = cell(nSets,1);
y = cell(nSets,1);
% for each set
for set = 1:1:nSets
    bLen = length(buildings{set});
    xList = zeros(bLen,1);
    yList = zeros(bLen,1);
    % for each building
    for b = 1:1:bLen
        % add the building's data to the cell array
        xList(b) = getFieldByPath(buildings{set}(b), x_field);
        yList(b) = getFieldByPath(buildings{set}(b), y_field);
    end
    x{set} = xList;
    y{set} = yList;
end

%% Plot
for set = 1:1:nSets
    plot(x{set},y{set}, ['d',cp(set)], ...
        'MarkerSize', 5, ...
        'MarkerFaceColor', cp(set))
    hold on
end
hold off

end

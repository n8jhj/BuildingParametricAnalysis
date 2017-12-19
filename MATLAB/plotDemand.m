function dataStruct = plotDemand(building, varargin)
%PLOTDEMAND View energy and power demand profiles.
% dataStruct = PLOTDEMAND(building)
%   Plots energy and power demand profiles for input building. Returns the
%   data struct of building.
%   building -  Either a string (file name) or a struct containing the name
%               and data for a building.
%
% dataStruct = PLOTDEMAND(building, funcName, varargin)
%   Outliers are set apart from the rest of the data with a different
%   plotting style.
%   funcName -  String. Name of function for determining outliers.
%   varargin -  Cell array with the additional arguments needed for certain functions.
%
% dataStruct = PLOTDEMAND(building, 'nofig', fieldName)
%   Plots field fieldName of building.data.
%   'nofig' -   Specifies that no figures should be explicitly created.
%
% Example:
%   dataStruct = PLOTDEMAND(building, 'quartiles', 2);
%   Plots energy and power demand profiles using function 'quartiles' to
%   find outliers, and with starting fence of 2 (outliers between fences 1
%   and 2 fences are not considered outliers).

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
if isempty(varargin) || ...
        (length(varargin) > 1 && ~strcmp(varargin{end-1},'nofig'))
    % Create figures when plotting
    % plot Energy
    field = 'totFacEn';
    fig1 = figure;
    [x,y,xOtlrs,yOtlrs] = setupPlotData(dataStruct,field,varargin{:});
    doPlotting(x,y,xOtlrs,yOtlrs,bName,field)
    
    % plot Power (or Demand)
    field = 'totFacDe';
    fig2 = figure;
    [x,y,xOtlrs,yOtlrs] = setupPlotData(dataStruct,field,varargin{:});
    doPlotting(x,y,xOtlrs,yOtlrs,bName,field)
    
    % clean up positioning of figures for better visibility
    positionFigures(fig1, fig2)
else
    % Don't create figures when plotting
    field = varargin{end};
    [x,y,xOtlrs,yOtlrs] = setupPlotData(dataStruct,field,varargin{:});
    doPlotting(x,y,xOtlrs,yOtlrs,bName,field)
end

end


%% Setup data used in plotting
function [x,y,xOtlrs,yOtlrs] = setupPlotData(dataStruct,field,varargin)
xOtlrs = [];
yOtlrs = [];
x = dataStruct.timestamp;
y = dataStruct.(field);
if ~isempty(varargin) && ...
        ~(length(varargin)==2 && strcmp(varargin{end-1},'nofig'))
    yOtlrs = getOutliers(dataStruct.(field), varargin{:});
    if ~isempty(yOtlrs)
        otlrInds = yOtlrs(:,1);
        xOtlrs = dataStruct.timestamp(otlrInds);
        y(otlrInds) = NaN;
    end
end
end


%% Perform mechanics of plotting
function doPlotting(x,y,xOtlrs,yOtlrs,bName,var)
plot(x, y)
hold on
if ~isempty(yOtlrs)
    plot(xOtlrs, yOtlrs(:,2), 'r*')
end
addFigureText(bName, var)
hold off
end


%% Add text to figure based on which variable was plotted
function addFigureText(bName,field)
switch field
    case 'totFacEn'
        title({bName, 'Total Facility Energy Demand'})
        xlabel('Timestamp')
        ylabel('Demand (kWh)')
    case 'totFacDe'
        title({bName, 'Total Facility Power Demand'})
        xlabel('Timestamp')
        ylabel('Demand (kW)')
    otherwise
        disp('Figure text could not be added; check plot variable name')
end
end

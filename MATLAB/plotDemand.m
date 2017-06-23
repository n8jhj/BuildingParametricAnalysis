function dataStruct = plotDemand(building, varargin)
%PLOTDEMAND View energy and power demand profiles.
%   dataStruct = plotDemand(building)
%   Plots energy and power demand profiles for input BUILDING. BUILDING may
%   be either a string of the file name or a struct containing the name and
%   data of a building. Returns the data struct of BUILDING.
%
%   dataStruct = plotDemand(building, funcName, varargin)
%   Outliers are set apart from the rest of the data by a different
%   plotting style. Outliers are determined by FUNCNAME, with additional
%   arguments VARARGIN needed for certain functions.
%
% Example:
%   dataStruct = plotDemand(building, 'quartiles', 2);
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
close all

if isempty(varargin)
    % Don't differentiate between outliers and other data
    % plot Energy
    fig1 = figure;
    plot(dataStruct.timestamp, dataStruct.totFacEn)
    addFigureText(bName, 'energy')
    
    % plot Power (or Demand)
    fig2 = figure;
    plot(dataStruct.timestamp, dataStruct.totFacDe)
    addFigureText(bName, 'power')
else
    % Set outliers apart
    % get outliers
    outliersEn = getOutliers(dataStruct.totFacEn, varargin{:});
    outliersDe = getOutliers(dataStruct.totFacDe, varargin{:});
    
    % setup plot data
    x = dataStruct.timestamp;
    yEn = dataStruct.totFacEn;
    yDe = dataStruct.totFacDe;
    if ~isempty(outliersEn)
        otlrIndsEn = outliersEn(:,1);
        xOtlrsEn = dataStruct.timestamp(otlrIndsEn);
        yEn(otlrIndsEn) = NaN;
    end
    if ~isempty(outliersDe)
        otlrIndsDe = outliersDe(:,1);
        xOtlrsDe = dataStruct.timestamp(otlrIndsDe);
        yDe(otlrIndsDe) = NaN;
    end
    
    % plot Energy
    fig1 = figure;
    plot(x, yEn)
    hold on
    if ~isempty(outliersEn)
        plot(xOtlrsEn, outliersEn(:,2), 'r*')
    end
    addFigureText(bName, 'energy')
    hold off
    
    % plot Power (or Demand)
    fig2 = figure;
    plot(x, yDe)
    hold on
    if ~isempty(outliersDe)
        plot(xOtlrsDe, outliersDe(:,2), 'r*')
    end
    addFigureText(bName, 'power')
    hold off
end
    
%% Clean up positioning of figures for better visibility
positionFigures(fig1, fig2)

end


function addFigureText(bName,variable)

%% Add text to figure based on which variable was plotted
switch variable
    case 'energy'
        title({bName, 'Total Facility Energy Demand'})
        xlabel('Timestamp')
        ylabel('Demand (kWh)')
    case 'power'
        title({bName, 'Total Facility Power Demand'})
        xlabel('Timestamp')
        ylabel('Demand (kW)')
    otherwise
        disp('Figure text could not be added; check plot variable name')
end

end

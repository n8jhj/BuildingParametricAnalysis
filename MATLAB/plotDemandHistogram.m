function plotDemandHistogram(building, varargin)
%PLOTDEMANDHISTOGRAM Histogram of building data by percentage of maximum
%demand.
%   plotDemandHistogram(building)
%   Plots histogram of BUILDING using automatically determined bin sizes.
%   BUILDING should be a struct with fields 'name' and 'data'.
%
%   plotDemandHistogram(building, 'nofig', fieldName)
%   Plots histogram of BUILDING field FIELDNAME without explicity creating
%   figures.

%% Plot
if isempty(varargin)
    % fig1
    fig1 = figure;
    field = 'totFacEn';
    doPlotting(building,field)
    
    % fig2
    fig2 = figure;
    field = 'totFacDe';
    doPlotting(building,field)
    
    % Clean up positioning of figures for better visibility
    positionFigures(fig1, fig2)
else
    field = varargin{2};
    doPlotting(building,field)
end

end

%% Perform mechanics of plotting
function doPlotting(building,field)
pcts = 100 * pctOfMax(building.data.(field));
histogram(pcts)
switch field
    case 'totFacEn'
        title({building.name, ...
            'Total Facility Energy Demand by Percent of Maximum'})
    case 'totFacDe'
        title({building.name, ...
            'Total Facility Power Demand by Percent of Maximum'})
end
xlabel('Percent of Maximum Overall Value (%)')
ylabel('Number of Data Points')
end

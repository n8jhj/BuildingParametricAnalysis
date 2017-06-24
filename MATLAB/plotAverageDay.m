function plotAverageDay(buildings, save)
%PLOTAVERAGEDAY Plot the average day's profiles and optionally save the
%figure as .png file for the input buildings.
%   plotAverageDay(buildings)
%   BUILDINGS is a list of building structures.
%
%   plotAverageDay(buildings,save)
%   SAVE is a boolean value. Default is false.

%% Handle inputs
if nargin < 2
    save = false;
end

%% Plot and optionally save pictures for each building
fdNames = fieldnames(buildings(1).avgDay);
fLen = length(fdNames);
for i = 1:1:length(buildings)
    fig = figure;
    bName = buildings(i).name;
    for j = 1:1:fLen
        subplot(fLen,1,j)
        plot(buildings(i).avgDay.(fdNames{j}))
        addFigText(bName,fdNames{j})
    end
    resizeFigure(fig)
    if save
        saveas(fig,strcat(bName,'_avgDay.png'))
    end
end

end


function addFigText(bName,fdName)
% add title and axes text
switch fdName
    case 'totFacEn'
        title({bName, ...
            strcat('Average Total Facility Energy Demand - One Day')})
        xlabel('Hour of Day')
        ylabel('Energy (kWh)')
    case 'totFacDe'
        title({bName, ...
            strcat('Average Total Facility Power Demand - One Day')})
        xlabel('Hour of Day')
        ylabel('Power (kW)')
    otherwise
        disp('Field name not recognized')
end
end


function resizeFigure(fig)
% resize height of fig
figPos = get(fig,'OuterPosition');
deltaH = 700;
figPos(2) = figPos(2) - deltaH;
figPos(4) = figPos(4) + deltaH;
set(fig,'OuterPosition',figPos)
end

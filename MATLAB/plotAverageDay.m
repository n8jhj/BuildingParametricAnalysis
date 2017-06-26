function plotAverageDay(buildings, save)
%PLOTAVERAGEDAY Plot the average day's profiles and optionally save the
%figure as .png file for the input buildings.
%   plotAverageDay(buildings,save)
%   BUILDINGS is the list of buildings for which the average day should be
%   plotted. SAVE is a boolean value specifying whether the figure should
%   be saved. Default is false.

%% Handle input
if nargin < 2
    save = false;
end

%% For each building, plot, resize, and optionally save
fdNames = fieldnames(buildings(1).avgDay);
fLen = length(fdNames);
for i = 1:1:length(buildings)
    bName = buildings(i).name;
    
    % Plot
    fig = figure;
    for j = 1:1:fLen
        subplot(fLen,1,j)
        plot(buildings(i).avgDay.(fdNames{j}))
        addFigText(bName,fdNames{j})
    end
    
    % Resize
    resizeFigure(fig)
    
    % Save
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
deltaW = -180;
figPos(2) = figPos(2) - deltaH;
figPos(4) = figPos(4) + deltaH;
figPos(3) = figPos(3) + deltaW;
set(fig,'OuterPosition',figPos)
end

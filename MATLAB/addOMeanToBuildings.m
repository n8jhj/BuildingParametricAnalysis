function buildings = addOMeanToBuildings(buildings)
%ADDOMEANTOBUILDINGS Add field containing overall mean of all data for each
%building in input BUILDINGS.
%   buildings = addOMeanToBuildings(buildings)
%   Returns list BUILDINGS with field 'omean' added.

%% Check for field 'avgDay'
if isfield(buildings(1), 'avgDay')
    % for each building
    for b = 1:1:length(buildings)
        % get fieldnames
        fdNames = fieldnames(buildings(b).avgDay);
        % for each field
        for f = 1:1:length(fdNames)
            % take the mean of the average day values
            avgDay = [buildings(b).avgDay.(fdNames{f})];
            buildings(b).omean.(fdNames{f}) = mean(avgDay);
        end
    end
else
    % throw an error
    error(strcat('Field ''avgDay'' is required for each building in', ...
        ' BUILDINGS. Run addAvgDayToBuildings first.'))
end

end

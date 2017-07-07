function buildings = addToBuildings(buildings, field)
%ADDTOBUILDINGS Add input FIELD to buildings.
%   buildings = addToBuildings(buildings, field)
%   Adds the specified input FIELD to the struct BUILDINGS and returns it.

%% Check for field 'nsteps'; add if non-existent
if ~isfield(buildings(1),'nsteps') && ~strcmp(field, 'days')
    buildings = addNStepsToBuildings(buildings);
    if strcmp(field,'nsteps')
        return
    end
end

%% Add input field to buildings
bLen = length(buildings);
% for each building
for b = 1:1:bLen
    try
        % add specified field
        switch field
            case 'days'
                [days,~] = partitionByDays(buildings(b).data);
                buildings(b).days = days;
            case 'mads'
                nSteps = buildings(b).nsteps;
                buildings(b).mads = ...
                    getMonthlyAvgDays(buildings(b).days,nSteps);
            otherwise
                % add requested field only for days with complete data sets
                ptsReqd = buildings(b).nsteps;
                buildings(b).days = ...
                    addToDays(buildings(b).days, field, ptsReqd);
        end
    catch ME
        fprintf('Error at building %i\n', b)
        rethrow(ME)
    end
end

end

function buildings = addToBuildings(buildings, field)
%ADDTOBUILDINGS Add input FIELD to buildings.
%   buildings = addToBuildings(buildings, field)
%   Adds the specified input FIELD to the struct BUILDINGS and returns it.

%% Necessary field checks and initialization
switch field
    case 'days'
        % pass
    case 'nsteps'
        if ~isfield(buildings,'days')
            buildings = addToBuildings(buildings,'days');
        end
    case 'avgDay'
        if ~isfield(buildings,'mads')
            buildings = addToBuildings(buildings,'mads');
        end
    case 'omean'
        if ~isfield(buildings,'avgDay')
            buildings = addToBuildings(buildings,'avgDay');
        end
    case 'avgTdr'
        if ~isfield(buildings(1).days,'tdr')
            buildings = addToBuildings(buildings,'tdr');
        end
    otherwise
        % 'nsteps' needed for all other cases
        if ~isfield(buildings,'nsteps')
            buildings = addToBuildings(buildings,'nsteps');
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
            case 'nsteps'
                buildings(b).nsteps = ...
                    getNStepsFromData(buildings(b).data);
            case 'mads'
                nSteps = buildings(b).nsteps;
                buildings(b).mads = ...
                    getMonthlyAvgDays(buildings(b).days,nSteps);
            case 'avgDay'
                buildings(b).avgDay = ...
                    getAvgDayFromADs(buildings(b).mads);
            case 'omean'
                buildings(b).omean = ...
                    getOMeanFromAvgDay(buildings(b).avgDay);
            case 'avgTdr'
                buildings(b).avgTdr = ...
                    getAvgTDRFromDays(buildings(b).days);
            case 'avgNomRng'
                buildings(b).avgNomRng = ...
                    getAvgNomRngFromDays(buildings(b).days);
            otherwise
                % add requested field for all days with complete data sets
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

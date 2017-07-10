function buildings = addToBuildings(buildings, field)
%ADDTOBUILDINGS Add input FIELD to buildings.
%   buildings = addToBuildings(buildings, field)
%   Adds the specified input FIELD to the struct BUILDINGS and returns it.

%% Necessary field checks and initialization
dependence = 'none';
switch field
    case 'days'
        % pass
    case 'nsteps'
        dependence = 'days';
    case 'avgDay'
        dependence = 'mads';
    case 'omean'
        dependence = 'avgDay';
    case 'avgTdr'
        dependence = {'days','tdr'};
    case 'pkOtlrs'
        dependence = {'days','nomRng'};
    otherwise
        % 'nsteps' needed for all other cases
        dependence = 'nsteps';
end
if ~strcmp(dependence,'none')
    buildings = ensureExistence(buildings,dependence);
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


%% Ensure existence of a field upon which fields to be added are predicated
function buildings = ensureExistence(buildings,dep)
%% Check for cell input
if ~iscell(dep)
    dep = {dep};
end

%% Set up for existence check
if length(dep) > 1
    reliant = getFieldByPath(buildings, [1, dep(1:end-1)]);
else
    reliant = buildings;
end

%% Check for existence of dependence
if ~isfield(reliant,dep{end})
    fprintf('Dependence field %s is being added...\n', dep{end})
    buildings = addToBuildings(buildings,dep{end});
end
end

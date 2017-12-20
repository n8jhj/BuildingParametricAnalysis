function buildings = addToBuildings(buildings, field)
%ADDTOBUILDINGS Add input FIELD to buildings.
% buildings = ADDTOBUILDINGS(buildings, field)
%   Adds the specified field to the struct buildings and returns it.
%   buildings - A struct of buildings.
%   field -     A string of the field name to add.

%% Necessary field checks and initialization
dependence = 'none';
switch field
    case 'days'
        % pass
    case {'nsteps','cumDem'}
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
        buildings(b) = addField(buildings(b),field);
    catch ME
        printError(ME)
        fprintf(2, strcat('Error at building %i.\n', ...
            'Returning input buildings...\n\n'), b);
        return
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


%% Perform addition of specified field to building
function bldg = addField(bldg,field)
switch field
    case 'days'
        [days,~] = partitionByDays(bldg.data);
        bldg.days = days;
    case 'nsteps'
        bldg.nsteps = getNStepsFromData(bldg.data);
    case 'mads'
        nSteps = bldg.nsteps;
        bldg.mads = getMonthlyAvgDays(bldg.days,nSteps);
    case 'avgDay'
        bldg.avgDay = getAvgDayFromADs(bldg.mads);
    case 'omean'
        bldg.omean = getOMeanFromAvgDay(bldg.avgDay);
    case 'avgTdr'
        bldg.avgTdr = getAvgTDRFromDays(bldg.days);
    case 'avgNomRng'
        bldg.avgNomRng = getAvgNomRngFromDays(bldg.days);
    otherwise
        % add requested field for all days with complete data sets
        ptsReqd = bldg.nsteps;
        bldg.days = addToDays(bldg.days, field, ptsReqd);
end
end

function [buildings, flag] = addToBuildings(buildings, field)
%ADDTOBUILDINGS Add input field to input buildings.
% [buildings, flag] = ADDTOBUILDINGS(buildings, field)
%   Adds the specified field to the struct buildings and returns it.
%   buildings - A struct of buildings.
%   field -     A string of the field name to add.
%   flag -      Specifies the result of adding the input field.
%       0   - Field successfully added to all buildings.
%       1   - Error encountered.

%% Necessary field checks and initialization
flag = 0;
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
        buildings = addField(buildings,b,field);
    catch ME
        printError(ME)
        fprintf(['Error at building %i in file ', mfilename, '\n', ...
            'Returning input buildings...\n\n'], b);
        flag = 1;
        return
    end
end

end


%% Internal functions
% Ensure existence of a field upon which fields to be added are predicated
function buildings = ensureExistence(buildings,dep)
% Check for cell input
if ~iscell(dep)
    dep = {dep};
end

% Set up for existence check
if length(dep) > 1
    reliant = getFieldByPath(buildings, [1, dep(1:end-1)]);
else
    reliant = buildings;
end

% Check for existence of dependence
if ~isfield(reliant,dep{end})
    fprintf('Dependence field %s is being added...\n', dep{end})
    buildings = addToBuildings(buildings,dep{end});
end
end


% Perform addition of specified field to building at given index in struct
function bldgStruct = addField(bldgStruct,index,field)
bldg = bldgStruct(index);
switch field
    case 'days'
        [days,~] = partitionByDays(bldg.data);
        bldgStruct(index).days = days;
    case 'nsteps'
        bldgStruct(index).nsteps = getNStepsFromData(bldg.data);
    case 'mads'
        nSteps = bldg.nsteps;
        bldgStruct(index).mads = getMonthlyAvgDays(bldg.days,nSteps);
    case 'avgDay'
        bldgStruct(index).avgDay = getAvgDayFromADs(bldg.mads);
    case 'omean'
        bldgStruct(index).omean = getOMeanFromAvgDay(bldg.avgDay);
    case 'avgTdr'
        bldgStruct(index).avgTdr = getAvgTDRFromDays(bldg.days);
    case 'avgNomRng'
        bldgStruct(index).avgNomRng = getAvgNomRngFromDays(bldg.days);
    otherwise
        % add requested field for all days with complete data sets
        ptsReqd = bldg.nsteps;
        bldgStruct(index).days = addToDays(bldg.days, field, ptsReqd);
end
end

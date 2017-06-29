function buildings = addMADsToBuildings(buildings)
%ADDMADSTOBUILDINGS Add monthly average days as a field to struct
%BUILDINGS.
%   buildings = addMADsToBuildings(buildings)
%   Returns the input struct BUILDINGS with new field 'mads', which
%   contains the average days for each month of the year for each building.

%% Check for fields 'days' and 'nsteps'
assert(isfield(buildings, 'days'), ...
    strcat('Input buildings must contain field ''days''.', ...
    ' Run addDaysToBuildings.m first.'))
assert(isfield(buildings, 'nsteps'), ...
    strcat('Input buildings must contain field ''nsteps''.', ...
    ' Run addNStepsToBuildings.m first.'))

%% Add field 'mads' for each building
for i = 1:1:length(buildings)
    nSteps = buildings(i).nsteps;
    nReqd = nSteps;
    buildings(i).mads = getMonthlyAvgDays(buildings(i).days,nSteps,nReqd);
end

end

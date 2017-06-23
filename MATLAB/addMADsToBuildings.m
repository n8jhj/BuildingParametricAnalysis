function buildings = addMADsToBuildings(buildings)
%ADDMADSTOBUILDINGS Add monthly average days as a field to struct
%BUILDINGS.
%   buildings = addMADsToBuildings(buildings)
%   Returns the input struct BUILDINGS with new field 'mads', which
%   contains the average days for each month of the year for each building.

%% Check for field days
assert(isfield(buildings, 'days'), ...
    strcat('Input buildings must contain field ''days''.', ...
    ' Run addDaysToBuildings.m first.'))

%% Add field 'mads' for each building
nSteps = 24;
nReqd = 24;
for i = 1:1:length(buildings)
    buildings(i).mads = getMonthlyAvgDays(buildings(i).days,nSteps,nReqd);
end

end

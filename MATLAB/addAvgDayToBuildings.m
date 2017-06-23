function buildings = addAvgDayToBuildings(buildings)
%ADDAVGDAYTOBUILDINGS Add overall average day as a field to struct
%BUILDINGS.
%   buildings = addAvgDayToBuildings(buildings)
%   Returns the input struct BUILDINGS with new field 'avgDay', which
%   contains the average day across the entire set of data for each
%   building.

%% Check for field 'mads'
assert(isfield(buildings, 'mads'), ...
    strcat('Input buildings must contain field ''mads''.', ...
    ' Run addMADsToBuildings.m first.'))

%% Add field 'avgDay' for each building
for i = 1:1:length(buildings)
    buildings(i).avgDay = getAvgDayFromADs(buildings(i).mads);
end

end

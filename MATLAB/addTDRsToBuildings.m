function buildings = addTDRsToBuildings(buildings)
%ADDTDRSTOBUILDINGS Get turndown ratios of days of input buildings and add
%them to the buildings struct.
%   buildings = addTDRsToBuildings(buildings)
%   Returns the input struct BUILDINGS with new fields 'tdrEn' and 'tdrDe'
%   within field 'days' of each building, which is the turndown ratio for
%   the energy and power demands in each day of data of each building.

%% Check for field days
assert(isfield(buildings, 'days'), ...
    strcat('Input buildings must contain field ''days''.', ...
    ' Run addDaysToBuildings.m first.'))

%% Add fields 'tdrEn' and 'tdrDe' for each building
for i = 1:1:length(buildings)
    buildings(i).days = addTDRsToDays(buildings(i).days);
end

end
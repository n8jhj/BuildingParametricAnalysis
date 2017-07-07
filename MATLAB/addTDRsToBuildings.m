function buildings = addTDRsToBuildings(buildings)
%ADDTDRSTOBUILDINGS Get turndown ratios of days of input buildings and add
%them to the buildings struct.
%   buildings = addTDRsToBuildings(buildings)
%   Returns the input struct BUILDINGS with new field 'tdr' within field
%   'days' of each building, which is the turndown ratio for the energy
%   and/or power demands in each day of data of each building.

%% Check for field days
assert(isfield(buildings, 'days'), ...
    strcat('Input buildings must contain field ''days''.', ...
    ' Run addDaysToBuildings.m first.'))

%% Add field 'tdr' in days
bLen = length(buildings);
% for each building
for b = 1:1:bLen
    try
        % add turndown ratio only for days with full data sets
        ptsReqd = buildings(b).nsteps;
        buildings(b).days = addTDRsToDays(buildings(b).days, ptsReqd);
    catch ME
        fprintf('Error at building %i\n', b)
        rethrow(ME)
    end
end

end

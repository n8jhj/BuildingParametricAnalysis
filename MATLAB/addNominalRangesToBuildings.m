function buildings = addNominalRangesToBuildings(buildings)
%ADDNOMINALRANGESTOBUILDINGS Add nominal range values (minimum range
%containing 95% of data values) for each day of each building in BUILDINGS.
%   building = addNominalRangesToBuildings(buildings)
%   Returns input struct BUILDINGS with new field 'nomRng' within field
%   'days' of each building, which is the nominal range for energy and/or
%   power demand in each day of data of each building.

%% Check for field 'nsteps'
assert(isfield(buildings(1),'nsteps'), ...
    'Input buildings must contain field ''nsteps''')

%% Add nominal ranges to buildings
bLen = length(buildings);
% for each building
for b = 1:1:bLen
    try
        % add nominal range only for days with full data sets
        ptsReqd = buildings(b).nsteps;
        buildings(b).days = ...
            addNominalRangesToDays(buildings(b).days, ptsReqd);
        fdNames = fieldnames(buildings(b).data);
        fLen = length(fdNames);
        % for each field
        for f = 1:1:fLen
            % add 'nomRng' to all days
            fn = fdNames{f};
            if strcmp(fn(1:6),'totFac')
                buildings(b).days = ...
                    addNominalRangesToDays(buildings(b).days, fn, ptsReqd);
            end
        end
    catch ME
        fprintf('Error at building %i\n', b)
        rethrow(ME)
    end
end

end

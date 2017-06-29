function buildings = addNStepsToBuildings(buildings)
%ADDNSTEPSTOBUILDINGS Gets the number of timesteps for the set of data of
%each building contained in BUILDINGS.
%   buildings = addNStepsToBuildings(buildings)
%   Returns BUILDINGS with field timestep added to each building.

%% Check input buildings for field 'days'
assert(isfield(buildings(1), 'days'), ...
    'Input BUILDING must have field DAYS. Run addDaysToBuildings first.')

%% Find min timestep and convert to max number timesteps for each building
for i = 1:1:length(buildings)
    tnum = datenum(buildings(i).data.timestamp);
    minStep = tnum(2) - tnum(1);
    for j = 3:1:length(tnum)
        step = tnum(j) - tnum(j-1);
        if step < minStep
            minStep = step;
        end
    end
    buildings(i).nsteps = int16(1 / minStep);
end

end

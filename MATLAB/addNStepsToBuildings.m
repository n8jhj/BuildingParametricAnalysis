function buildings = addNStepsToBuildings(buildings)
%ADDNSTEPSTOBUILDINGS Gets the number of timesteps in one day for each
%building contained in BUILDINGS.
%   buildings = addNStepsToBuildings(buildings)
%   Returns BUILDINGS with field timestep added to each building.

%% Check for field 'days'; add if non-existent
if ~isfield(buildings(1),'days')
    buildings = addDaysToBuildings(buildings);
end

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

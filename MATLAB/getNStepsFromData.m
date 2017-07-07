function nsteps = getNStepsFromData(data)
%GETNSTEPSFROMDATA Number of timesteps in one day
%   nsteps = getNStepsFromData(data)
%   Returns number of timesteps in one day, given struct DATA, which
%   contains field 'timestamp'.

%% Find min timestep; convert to max number timesteps
tnum = datenum(data.timestamp);
minStep = tnum(2) - tnum(1);
for i = 3:1:length(tnum)
    step = tnum(i) - tnum(i-1);
    if step < minStep
        minStep = step;
    end
end
nsteps = int16(1 / minStep);

end

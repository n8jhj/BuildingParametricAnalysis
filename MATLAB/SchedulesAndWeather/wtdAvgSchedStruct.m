function avg_sch_struct = wtdAvgSchedStruct(bldg_type,avg_params,wt_params)
%WTDAVGSCHEDSTRUCT Weighted average of input schedule structure based on
%input weighting parameters.
%   avg_sch_struct = wtdAvgSchedStruct(bldg_type,avg_params,wt_params)
%   Returns the weighted average of all schedules of the prototype building
%   BLDG_TYPE. AVG_PARAMS is a cell array of field names for which there is
%   at least one schedule. WT_PARAMS may be either a list of parameters to
%   weight by, or just one parameter, if the weighting parameters are all
%   the same.
%
% Example:
%   building.Schedule = wtdAvgSchedStruct('Hospital',{'equipment','lighting','occupancy','cooling','heating'},'floor_area');

%% Handle input
% Allow for input cell array of weighting factors.
if ~iscell(wt_params)
    temp = cell(length(avg_params),1);
    temp(:) = {wt_params};
    wt_params = temp;
end
% Now it may be assumed that wt_params is a cell array of weighting
% factors.

%% Initialize struct
avg_sch_struct = struct(avg_params{1},[]);
for p = 2:1:length(avg_params)
    avg_sch_struct.(avg_params{p}) = [];
end

%% Get weighted average schedule for each input parameter
for p = 1:1:length(avg_params)
    avg_sch_struct.(avg_params{p}) = ...
        getAvgSched(bldg_type,avg_params{p},wt_params{p});
end

end


%% Get weighted average schedule for a particular field
function avg_sch_tot = getAvgSched(b_type,a_param,w_param)

%% Get weighting parameter for each space
wts = spaceParameters(b_type,w_param);

%% Get schedules for each of Weekday, Saturday, and Sunday
spc_sched_names = spaceSchedNames(b_type,a_param);
[seasons,wkdy_scheds,sat_scheds,sun_scheds] = ...
    spaceSchedules(spc_sched_names);

%% For each of the Weekday, Sat, and Sun schedules...
scheds = {wkdy_scheds,sat_scheds,sun_scheds};
for i = 1:1:3
    sched = scheds{i};
    % expand schedule to list containing 24 values; one for each hour
    sched = expandScheds(sched);
    % convert schedule to matrix for weighted averaging
    sch_mat = sched2Mat(sched);
    % calculate weighted average
    avg_mat = wtdAvgSchMat(sch_mat,wts);
    % convert matrix back to schedule
    avg_sch = mat2Sched(avg_mat);
    % collapse schedule back to the "until-value" form
    avg_sch = collapseScheds(avg_sch);
    % store the averaged schedule
    scheds{i} = avg_sch;
end

%% Store the results in a struct
avg_sch_tot = struct('Seasons',[],'Weekday',[],'Sat',[],'Sun',[]);
avg_sch_tot.Seasons = seasons;
avg_sch_tot.Weekday = scheds{1};
avg_sch_tot.Sat = scheds{2};
avg_sch_tot.Sun = scheds{3};

end

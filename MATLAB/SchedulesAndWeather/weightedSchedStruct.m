function wtdSch = weightedSchedStruct(bldgType,avg_params,wt_params)
%WEIGHTEDSCHEDSTRUCT Struct containing information about weighted schedules
%for a given prototype building.
%   wtdSch = weightedSchedStruct(bldgType,avg_params,wt_params)
%   Returns a struct containing the weighted schedules of the input
%   parameters, given by AVG_PARAMS. WT_PARAMS may be either a list of
%   parameters to weight by, or just one parameter, if the weighting
%   parameters are all the same.
%
% Example:
%   building.Schedule = weightedSchedules('Hospital',{'equipment','lighting','occupancy','cooling','heating'},'floor_area');

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
wtdSch = struct(avg_params{1},[]);
for p = 2:1:length(avg_params)
    wtdSch.(avg_params{p}) = [];
end

%% Get weighted average for each input parameter
for p = 1:1:length(avg_params)
    % get schedules to be averaged
    scheds = spaceSchedules(bldgType,avg_params{p});
    % get weights to be used
    [weights,~] = spaceParameters(bldgType,wt_params{p});
    % calculate weighted average schedule and store in return structure
    wtdSch.(avg_params{p}) = wtdAvgSched(scheds,[weights{:,2}]);
end

end

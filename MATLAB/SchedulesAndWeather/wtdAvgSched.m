function avgSched = wtdAvgSched(schedules,weights)
%WTDAVGSCHED Weighted average schedule of input schedules.
%   avgSched = wtdAvgSched(schedules,weights)
%   Returns the averaged schedule for the input schedules SCHEDULES and
%   input weights WEIGHTS. Assume 24 hours in each schedule. Input
%   SCHEDULES should be a cell array of lists.

%% Get 24xN matrix of schedules: hours on rows, schedules on columns
scheds = TwentyFourHrSched(schedules);

%% Initialize
hours = 1:1:24;
avgSched = zeros(24,1);

%% Calculate weighted averages
for h = hours
    avgSched(h) = wtdAvg(scheds(h,:), weights);
end

end

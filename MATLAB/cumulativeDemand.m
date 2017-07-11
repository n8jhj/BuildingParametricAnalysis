function cumDem = cumulativeDemand(day)
%CUMULATIVEDEMAND Cumulative demand profile for DAY.
%   cumDem = cumulativeDemand(day)
%   Returns input DAY in terms of what percentage of the total demand for
%   that day has been demanded up to each point. Input DAY is a list of
%   doubles.

%% Get cumulative demand profile for the day
total = sum(day);
tLen = length(day);
cumDem = zeros(tLen,1);
running = 0;
for t = 1:1:tLen
    cumDem(t) = running + day(t)/total;
    running = cumDem(t);
end
cumDem(end) = round(cumDem(end));

%% Check for sum of 1
assert(cumDem(end) == 1, 'Cumulative demand does not add up to one')

end

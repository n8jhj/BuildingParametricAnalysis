function weekdays = getWeekdays(data)
%GETWEEKDAYS Return list of weekday numbers based on input DATA.
%   weekdays = getWeekdays(data) Creates array WEEKDAYS of DATA and then
%   returns it. Input DATA must be a struct, and is assumed to be
%   partitioned by days.

weekdays = zeros(length(data),1);
for i = 1:1:length(weekdays)
    if ~isempty(data(i).timestamp)
        weekdays(i) = weekday(data(i).timestamp(1));
    end
end

end
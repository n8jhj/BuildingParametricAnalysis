function omean = getOMeanFromAvgDay(avgDay)
%GETOMEANFROMAVGDAY Overall mean, calculated using the average day.
%   omean = getOMeanFromAvgDay(avgDay)
%   Returns the mean of all values in AVGDAY.

%% Get fieldnames
fdNames = fieldnames(avgDay);

%% Take the mean of the average day values
fLen = length(fdNames);
% for each field
for f = 1:1:fLen
    avdList = [avgDay.(fdNames{f})];
    omean.(fdNames{f}) = mean(avdList);
end

end

function demand = getMonthlyAvgDays(data)
%demand = getMonthlyAvgDays(data)
% INPUTS:
%   data        __x2 double with values in col 1, datenums in col 2
% OUTPUTS:
%   demand      __x12 double with average days for each month
% 
% Assumes uniformly spaced timesteps
% Assumes exactly one year of data

% get timestep
tstep = data(2,2) - data(1,2);

% separate data into months
months = month(datetime(data(:,2), 'ConvertFrom', 'datenum'));

% get number indices in each month
lastIndex = zeros(12,1);
for i = 1:1:12
    lastIndex(i) = find(months==i, 1, 'last');
end

% get number days in each month
nStepsFeb = lastIndex(2) - lastIndex(1) + 1;
nDaysFeb = ceil(nStepsFeb * tstep);
nDaysInMonth = [31;nDaysFeb;31;30;31;30;31;31;30;31;30;31];

% average each day
nStepsInDay = 1/tstep;
demand = ones(31/tstep, 12) .* NaN;
for i = 1:1:12 % each month
    for j = 1:1:nDaysInMonth(i) % each day
        create running average in demand
    end
end

end
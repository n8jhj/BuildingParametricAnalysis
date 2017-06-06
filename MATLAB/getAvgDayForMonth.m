function demand = getAvgDayForMonth(data)
%demand = getAvgDayForMonth(data)
% data should be ___x2 double with values in col 1, datenums in col 2

% separate data into months

% get average day for each month

tstep = data(2,2)-data(1,2);
dstep = 1; % length of day on datenum scale

% get length of day in indices
prev = tstep;
i = 1;
condition = 1;
while mod(date(i,1), 1) < prev
    prev = mod(data(i,1), 1);
    i = i+1;
end

% average each day

end
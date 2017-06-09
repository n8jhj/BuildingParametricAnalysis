function demand = ESO_getCSVData(fileName)
R1 = 1; % first row (row 0) contains column headers
C1 = 1; % first col (col 0) contains datetime
data = csvread(fileName, R1, C1);
vals = data(:, 21);
tstep = 1/(24*6); % assume 10 minute timestep
cyr = year(datetime(date)); % current year
tstart = datenum(strcat('01-Jan-', num2str(cyr))); % assume start at 01/01
time = (tstart : tstep : tstart+365-tstep)';
demand = [vals, time];
end
function demand = getElectricDemandFromCSVs(fileName)
R1 = 1; % first row (row 0) contains column headers
C1 = 1; % first col (col 0) contains datetime
data = csvread(fileName, R1, C1);
demand = data(:, 17-C1); % 
end
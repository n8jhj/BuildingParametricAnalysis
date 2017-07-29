function opt_res = calibrateResistance(b_type,weather)
%CALIBRATERESISTANCE Calibrates resistance parameter of input prototype
%building based on percent error of sum of total demand.

%% Get original directory
orig_dir = pwd;

%% Try main function
try
    [x,y,bldg] = main(b_type,weather);
    cd(orig_dir)
catch ME
    cd(orig_dir)
    rethrow(ME)
end

end


%% Working function
function [x,y,bldg] = main(b_type,wthr)
%% Load building data
cd 'C:\Users\Admin\Documents\GitHub\BuildingParametricAnalysis\MATLAB\PrototypeBuildingCreation\formatted_buildings'
load(strcat(b_type,'.mat'))         % building
load(strcat('../../Weather/',wthr)) % weather
load(strcat('mtr_',bldg,'.mat'))    % mtr
Date = (datenum(mtr.Timestamp(1)) : 1/24 : datenum(mtr.Timestamp(end))).';

%% Get E+ Data
P_Total = mtr.ElectricityFacility;

%% Optimize resistance
err = 1;
err_last = err;
res_prev = building.Resistance;
last_change = 1;
while err > 0.01
    % run EAGERS method
    [Equipment,Lighting,Cooling,Heating,Fan_Power] = BuildingProfile(building,weather,Date);
    Electric = Equipment + Lighting;
    G_Total = Electric + Cooling + Heating + Fan_Power;
    
    % calculate error
    err = (G_Total - P_Total) / P_Total;
    
    % did error improve or not?
    e_change = abs(err_last) - abs(err);
    
    % adjust resistance
    if e_change > 0
        building.Resistance = building.Resistance + e_change*last_change;
    end
    
    % keep track of error and previous resistance value
    err_last = err;
    res_prev = building.Resistance;
end

end

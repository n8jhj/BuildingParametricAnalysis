function wStruct = importWeatherDataToStruct(zone)
%IMPORTWEATHERDATATOSTRUCT Import weather data from .epw file to MATLAB
%struct.

%% Get to EPW files directory
origDir = pwd;
cd 'C:\\Users\Admin\Documents\EnergyPlus\Climate Zones - TMY3'
dirList = dir;

%% Get to proper zone directory
for d = 1:1:length(dirList)
    thisDir = dirList(d).name;
    thisZone = strtok(thisDir);
    if strcmp(thisZone,zone)
        cd(thisDir)
        break
    end
end
zoneDir = dir;

%% Import
for d = 1:1:length(zoneDir)
    thisDir = zoneDir(d).name;
    if length(thisDir) > 3 && strcmp(thisDir(end-3:end), '.epw')
        filename = thisDir;
        break
    end
end
assert(exist('filename','var')==1, 'File name not defined')
[yr,mo,dy,hr,mn,tDB,tWB,relHum] = importWeatherData(filename,9,Inf);

%% Get timestamp list
timestamp = datetime(num2str([yr,mo,dy,hr,mn]), ...
    'InputFormat','yyyy     M     d     H     m');

%% Convert NaT values to actual datetime values
step = 1/24;
natInds = find(isnat(timestamp));
for i = natInds
    timestamp(i) = timestamp(i-1) + step;
end

%% Create return struct
wStruct = struct(...
'zone',zone,...
'timestamp',timestamp,...
'tdb',tDB,...
'twb',tWB,...
'relHum',relHum...
);

%% Change back to original directory
cd(origDir)

end

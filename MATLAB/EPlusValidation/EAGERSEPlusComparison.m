function [x,y,fig] = EAGERSEPlusComparison(bldg,wthr,varargin)
%EAGERSEPLUSCOMPARISON Compare outputs of EAGERS and EnergyPlus
%   [x,y] = EAGERSEPlusComparison(bldg,wthr)
%   Plots demand profiles of EAGERS and EnergyPlus versions on same figure.
%
% Example:
%   [x,y,fig] = EAGERSEPlusComparison('SmallOffice','4A',1);

%% Get original directory
origDir = pwd;

%% Try running function
try
    % run function
    [x,y,fig] = main(bldg,wthr,varargin{:});
    % go back to original dir
    cd(origDir)
catch ME
    % be sure to go back to original dir
    cd(origDir)
    rethrow(ME)
end
end


%% Working function
function [x,y,fig] = main(bldg,wthr,varargin)
%% Load data
cd 'C:\Users\Admin\Documents\GitHub\BuildingParametricAnalysis\MATLAB\SchedulesAndWeather\formatted'
load(strcat(bldg,'.mat'))           % building
load(strcat('../weather/',wthr))    % weather
load(strcat('mtr_',bldg,'.mat'))    % mtr
Date = (datenum(mtr.Timestamp(1)) : 1/24 : datenum(mtr.Timestamp(end))).';

%% Run EAGERS method
[Equipment,Lighting,Cooling,Heating] = BuildingProfile(building,weather,Date);
Electric = Equipment + Lighting;
Total = Electric + Cooling + Heating;

%% Plot setup
if ~isempty(varargin)
    ver = num2str(varargin{1});
else
    ver = '*';
end
x = mtr.Timestamp;
% mtrTotal = ...
%     mtr.InteriorLightsElectricity + mtr.InteriorEquipmentElectricity;
y = {Lighting,Equipment,Cooling,Heating,[],Total; ...
    mtr.InteriorLightsElectricity,mtr.InteriorEquipmentElectricity,mtr.CoolingElectricity,mtr.HeatingElectricity,mtr.ElectricityHVAC,mtr.ElectricityFacility};
oTitle = ['v',ver,' - ',bldg,' - ',wthr];
titles = {'InteriorLights','Equipment','Cooling','Heating',[],'Total'; 'InteriorLights','Equipment','Cooling','Heating','HVAC','Total'};
xlab = '';
ylab = 'Load (kWh)';

%% Plot
fig = figure;
subplotComparison(x,y,oTitle,titles,xlab,ylab)

%% Resize
fig = resize(fig);
end


%% Resize input figure for readability
function fig = resize(fig)
deltaW = 800;
deltaH = 650;
figPos = get(fig,'OuterPosition');
figPos(3) = figPos(3) + deltaW;
figPos(4) = figPos(4) + deltaH;
figPos(2) = figPos(2) - deltaH;
set(fig,'OuterPosition',figPos)
end

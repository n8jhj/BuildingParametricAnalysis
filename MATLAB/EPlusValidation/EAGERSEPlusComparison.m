function [x,y,fig] = EAGERSEPlusComparison(bldg,wthr,varargin)
%EAGERSEPLUSCOMPARISON Compare outputs of EAGERS and EnergyPlus
%   [x,y,fig] = EAGERSEPlusComparison(bldg,wthr)
%   Plots demand profiles of EAGERS and EnergyPlus versions on same figure.
%
%   [x,y,fig] = EAGERSEPlusComparison(bldg,wthr,ver)
%   Optional input VER is the version number of this run. It will be shown
%   in the subplot titles.
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
cd 'C:\Users\Admin\Documents\GitHub\BuildingParametricAnalysis\MATLAB\PrototypeBuildingCreation\formatted_buildings'
load(strcat(bldg,'.mat'))           % building
load(strcat('../../Weather/',wthr)) % weather
load(strcat('mtr_',bldg,'.mat'))    % mtr
Date = (datenum(mtr.Timestamp(1)) : 1/24 : datenum(mtr.Timestamp(end))).';

%% Run EAGERS method
[Equipment,Lighting,Cooling,Heating,Fan_Power] = BuildingProfile(building,weather,Date);
Electric = Equipment + Lighting;
Total = Electric + Cooling + Heating + Fan_Power;

%% Plot setup
if ~isempty(varargin)
    ver = num2str(varargin{1});
else
    ver = '*';
end
x = mtr.Timestamp;
HVAC = Heating + Cooling + Fan_Power;
y = {
    Lighting,           mtr.InteriorLightsElectricity;
    [],                 mtr.ExteriorLightsElectricity;
    Equipment,          mtr.InteriorEquipmentElectricity;
    [],                 mtr.WaterSystemsElectricity;
    Cooling,            mtr.CoolingElectricity;
    Heating,            mtr.HeatingElectricity;
    Fan_Power,          mtr.FansElectricity;
    HVAC,               mtr.ElectricityHVAC;
    Total,              mtr.ElectricityFacility;
    }';
titles = {
    'InteriorLights',   'InteriorLights';
    'ExteriorLights',   'ExteriorLights';
    'Equipment',        'Equipment';
    'WaterSystems',     'WaterSystems';
    'Cooling',          'Cooling';
    'Heating',          'Heating';
    'Fans',             'Fans';
    'HVAC',             'HVAC';
    'Total',            'Total';
    }';
oTitle = ['v',ver,' - ',bldg,' - ',wthr];
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
deltaH = 800;
figPos = get(fig,'OuterPosition');
figPos(3) = figPos(3) + deltaW;
figPos(4) = figPos(4) + deltaH;
figPos(2) = figPos(2) - deltaH;
set(fig,'OuterPosition',figPos)
end

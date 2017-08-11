function [Equipment,InteriorLighting,ExteriorLighting,Cooling,Heating,Fan_Power,OtherLoads] = BuildingProfile(varargin)
% This function estimates the energy profile of a building (electric, heating and cooling kW)
% Build is a structure of building parameters
% Weather is an hourly weather profile (dry bulb, wet bulb, and relative humidity)
% Date is a vector of points in datenum format at which you are requesting the electric cooling & heating power

%% Constants
AIR_DENSITY = 1.225; % kg/m^3

%% Initialize
Build = varargin{1};
Weather = varargin{2};
Date = varargin{3};
if length(varargin)>3
    Location = varargin{4};
else Location = [];
end
[Y,Month,D,H,M,S] = datevec(Date);
h1 = H(1)+M(1)+S(1);
D(H==0&M==0&S==0) = D(H==0&M==0&S==0)-1;
H(H==0&M==0&S==0) = 24;%change hour 0 to hour 24 for interpolating
if h1 ==0%put start date back.
    D(1) = D(1) + 1;
    H(1) = 0;
end
days = ceil(Date(end) - datenum([Y(1),Month(1),D(1)]));
daysAfter1_1_17 = floor(Date(1)) - datenum([2017,1,1]);
wd = 1 + mod(daysAfter1_1_17,7); %day of the week, sunday is 1, saturday is 7
sd = floor(Date(1)); %start date
nS = length(Date);
dt1 = Date(2) - Date(1);
dt = 86400*(Date - [Date(1)-dt1;Date(1:end-1)]); %duration of each time segment
%calculate minimum air flow rate using density of air: 1.225 kg/m^3
MinFlow = Build.VariableStruct.Volume*AIR_DENSITY*(Build.VariableStruct.AirChangePerHr/100)*(1/3600); %kg/s of flow

%% Fill out schedule values for each timestep in input Date
%if next point in schedule is shorter than ramp, then ramp shortens to half the gap
sched = fieldnames(Build.Schedule);
for i = 1:1:length(sched)
    Profile.(sched{i}) = zeros(nS,1);
end
Tdb = zeros(nS,1); % Drybulb temperature
RH = zeros(nS,1); % Humidity ratio
Cooling = zeros(nS,1);
Heating = zeros(nS,1);
AirFlow = zeros(nS,1); % m^3/s
h8761 = (0:1:8760)';
p = 1;
DateIndex = cell(days);
for d = 1:1:days
    h_of_y = 24*(Date(p) - datenum([Y(p),1,1])); %hour since start of year
    %Load schedules for this day
    Out = loadSched(Build,wd,h_of_y);
    p2 = p;
    while p2<nS && Date(p2)<=sd+d
        p2 = p2+1;
    end
    if Date(p2)>sd+d
        p2 = p2-1;
    end
    for i = 1:1:length(sched)
        Profile.(sched{i})(p:p2) = interp1(Out.(sched{i})(:,1),Out.(sched{i})(:,2),H(p:p2)+M(p:p2)/60+S(p:p2)/3600);
    end
    h_of_y = 24*(Date(p:p2) - datenum([Y(p),1,1])); %hour since start of year
    Tdb(p:p2) = interp1(h8761,[Weather.Tdb(1);Weather.Tdb],h_of_y);
    RH(p:p2) = interp1(h8761,[Weather.RH(1);Weather.RH],h_of_y);
    DateIndex(d) = {p:p2};
    p = p2+1;
    wd = wd+1;
    if wd == 8
        wd = 1;
    end
end

%% Equipment load values
Equipment = Build.Area*Build.VariableStruct.equipment/1000*Profile.equipment;% kW of equipment load
if isfield(Build.VariableStruct,'DataCenter')
    Equipment = Equipment + Build.VariableStruct.DataCenter*Profile.datacenter;
end

%% Other load values
OtherLoads = zeros(nS,1);
if isfield(Build.VariableStruct,'WaterSystem')
    OtherLoads = Build.Area*Build.VariableStruct.WaterSystem*Profile.watersystem;
end

%% Exterior lighting load values
if isfield(Profile,'exteriorlights_solarcontroled')
    for day = 1:days
        HoD = 24*(Date(DateIndex{day}) - floor(Date(DateIndex{day}(1)))); %hour of day
        frac_dark = ones(length(HoD),1);
        if ~isempty(Location)
            [Sunrise,Sunset,~,~] = SolarCalc(Location.Longitude,Location.Latitude,Location.TimeZone,floor(Date(DateIndex{day}(1))));
        elseif isfield(Build,'Longitude') %moving location into node structure of network
            [Sunrise,Sunset,~,~] = SolarCalc(Build.Longitude,Build.Latitude,Build.TimeZone,floor(Date(DateIndex{day}(1))));
        else [Sunrise,Sunset,~,~] = SolarCalc(-105,40,-6,floor(Date(DateIndex{day}(1))));
        end
        h_sr = 1;
        while HoD(h_sr)<(Sunrise*24+.125) && h_sr<length(HoD)
            h_sr = h_sr+1;
        end
        if h_sr == 1
            frac_dark(1) = (Sunrise*24+.125)/HoD(1);
        else
            frac_dark(h_sr) = ((Sunrise*24+.125) - HoD(h_sr-1))/(HoD(h_sr)-HoD(h_sr-1));
        end
        h_ss = h_sr+1;
        if h_ss<length(HoD)
            while HoD(h_ss)<(Sunset*24-.125)  && h_ss<length(HoD)
                h_ss = h_ss+1;
            end
            frac_dark(h_ss) = 1-((Sunset*24-.125) - HoD(h_ss-1))/(HoD(h_ss)-HoD(h_ss-1));
        end
        frac_dark(h_sr+1:h_ss-1) = 0;
        Profile.exteriorlights_solarcontroled(DateIndex{day}) = min(Profile.exteriorlights_solarcontroled(DateIndex{day}'),frac_dark);
    end
    ExteriorLighting = Build.VariableStruct.ExteriorLights*Profile.exteriorlights_fixed + Build.VariableStruct.ExteriorLights*Profile.exteriorlights_solarcontroled;
else
    ExteriorLighting = Build.VariableStruct.ExteriorLights*Profile.exteriorlights;
end

%% Interior lighting load values
InteriorLighting = Build.Area*Build.VariableStruct.InteriorLights/1000*(Profile.interiorlights.*(1-Profile.daylighting));% kW of lighting load

%% Solar gain
SolarGain = 2*Build.Area*Build.VariableStruct.InteriorLights/1000*(Profile.interiorlights.*Profile.daylighting);% kW of solar energy entering (factor of 2 for IR entering with visible)

%% Internal gains
InternalGains = Build.Area*Build.VariableStruct.occupancy*Profile.occupancy*.120 + Equipment + InteriorLighting + SolarGain; %heat from occupants (120 W)

%% Ambient dewpoint
P = 101.325; %atmospheric pressure (kPa)
Tdb_K = Tdb+273.15; %Tdb (Kelvin)
satP = exp((-5.8002206e3)./Tdb_K + 1.3914993 - 4.8640239e-2*Tdb_K + 4.1764768e-5*Tdb_K.^2 - 1.4452093e-8*Tdb_K.^3 + 6.5459673*log(Tdb_K))/1000; %saturated water vapor pressure ASHRAE 2013 fundamentals eq. 6 in kPa valid for 0 to 200C
P_H2O = RH/100.*satP;
Tdp = 6.54 + 14.526*log(P_H2O) + 0.7389*log(P_H2O).^2 + 0.09486*log(P_H2O).^3 + 0.4569*(P_H2O).^0.1984; %Dew point from partial pressure of water using ASHRAE 2013 Fundamentals eqn 39 valid from 0C to 93C
Cp_amb = 1.006 + 1.86*(.621945*(P_H2O./(P-P_H2O))); %kJ/kg

%% Specific heat of air
% Tsupply = 22+273.15;
% P = 101.325;
% satP = exp((-5.8002206e3)./Tset + 1.3914993 - 4.8640239e-2*Tset + 4.1764768e-5*Tset.^2 - 1.4452093e-8*Tset.^3 + 6.5459673*log(Tset))/1000; %saturated water vapor pressure ASHRAE 2013 fundamentals eq. 6 in kPa valid for 0 to 200C
% P_H2O = exp(5423*(1/273-1./(273+Build.VariableStruct.DPset)))./exp(5423*(1/273-1./(273+Tset))).*satP;%Clausius-Clapeyron equation to calculate relative humidity from dewpoint temperature
% w = (P_H2O/(P-P_H2O));
w = 0.0085;
Cp_build = 1.006 + 1.86*(.621945*w); %kJ/kg

%% Heating/cooling dynamics
%need to step through time to account for moments with no heating/cooling
%as the building moves between the heat setpoint and the cooling setpoint
T_Cset = min(Profile.TsetC);
T_Hset = max(Profile.TsetH);
if (Profile.TsetH(1) - Tdb(1))*Build.Area/Build.VariableStruct.Resistance>InternalGains(1)
    Tact = Profile.TsetH(1); %initially in heating mode
elseif (Profile.TsetC(1) - Tdb(1))*Build.Area/Build.VariableStruct.Resistance<InternalGains(1)
    Tact = Profile.TsetC(1); %initially in cooling mode
else %initially in equilibrium between the heating and cooling setpoints
    Tact = (T_Cset + T_Hset)/2;
end

for t = 1:1:nS
    %% Determine the energy addition needed to achieve comfort
    Energy2Add = -((Tdb(t) - Profile.TsetH(t))*Build.Area/Build.VariableStruct.Resistance + InternalGains(t)) - (Tact - Profile.TsetH(t))*Build.VariableStruct.Capacitance*Build.Area/dt(t); %net energy needed to be added in kJ/s
    
    %% Predict behavior of HVAC
    if Energy2Add>0
        Tact = Profile.TsetH(t);
        Flow = MinFlow;
        Damper = Build.VariableStruct.MinDamper; %treat as little ouside air as possible
        Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
        Tsupply = Energy2Add/(Flow*Cp_Air) + Tact; %temperature of supply air to provide this heating
        Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
        Heating(t) = Cp_Air*(Tsupply-Tmix)*Flow;
    else
        Heating(t) = 0;
        Energy2Remove = ((Tdb(t) - Profile.TsetC(t))*Build.Area/Build.VariableStruct.Resistance + InternalGains(t)) + (Tact - Profile.TsetC(t))*Build.VariableStruct.Capacitance*Build.Area/dt(t); %net energy needed to be removed in kJ/s
        if Energy2Remove>0 %would exceed cooling setpoint without intervention       
            Tact = Profile.TsetC(t);
            Tsupply = Build.VariableStruct.ColdAirSet;
            if Tdb(t)<Tact %find economizer position
                if Tdb(t)>Tsupply
                    Damper = 1;
                else
                    Damper = (Tsupply - Tact)/(Tdb(t) - Tact);
                end
            else
                Damper = Build.VariableStruct.MinDamper; %treat as little ouside air as possible
            end
            Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
            Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
            Flow = Energy2Remove/((Tact-Tsupply)*Cp_Air); %mass flow of air to provide this cooling
            Cooling(t) = Cp_Air*(Tmix-Tsupply)*Flow;
        else
            Damper = Build.VariableStruct.MinDamper;
            Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
            Tsupply = Tmix;
            Cooling(t) = 0;
            Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
            Flow = 0;%MinFlow;
            Tact = Tact + ((Tdb(t) - Tact)*Build.Area/Build.VariableStruct.Resistance + InternalGains(t) + (Tmix - Tact)*Cp_Air*Flow).*dt(t)/(Build.VariableStruct.Capacitance*Build.Area); %net change in temperature
        end
    end
    AirFlow(t) = Flow/AIR_DENSITY;%flow rate in m^3/s
    
   %% Remove non-daytime heating and cooling
   if Profile.TsetC(t)>26 || Profile.TsetH(t)<19
       AirFlow(t) = 0;
       if Heating(t)>0
           Tact = T_Hset;
           Heating(t) = 0;
       end
       if Cooling(t)>0
           Tact = T_Cset;
           Cooling(t) = 0;
       end
   end
   
   %% Fixed fan power (i.e. On/Off)
   if Profile.TsetH(t)>19 %fan is on
       AirFlow(t) = MinFlow*10.75;
   else
       AirFlow(t) = 0;
   end
   
    
%     %% De-Humidification
%     %estimate de-humidification with Cp
%     if Tdp(t)>Build.VariableStruct.DPset %must dehumidify incoming air
%         Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
%         Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
%         Cooling(t)  = Flow*Cp_Air*(Tmix - Build.VariableStruct.DPset); %dehumidification energy in kJ/s
%         Heating(t)  = Flow*Cp_Air*(Tsupply - Build.VariableStruct.DPset); %dehumidification energy in kJ/s
%     end
%     
% %     %%full enthalpy calculations
% %     if Tdp(t)>Build.VariableStruct.DPset %must dehumidify incoming air
% %         %ambient air
% %         AmbientAir = makeAir(Tdb(t),RH(t),Damper*Flow,'rel');
% %         %recirculated air
% %         RecircAir = makeAir(Tact,Build.VariableStruct.DPset,(1-Damper)*Flow,'dp');
% %         %mixed air
% %         MixedAir = MixAir(RecircAir,AmbientAir);
% %         CooledAir = MixedAir;
% %         CooledAir.T = Build.VariableStruct.DPset+273.15; 
% %         sat_atDP = makeAir(Build.VariableStruct.DPset,100,Flow,'rel');
% %         CooledAir.H2O = sat_atDP.H2O; %remove water
% %         Cooling(t)  = (-enthalpyAir(MixedAir)*(MassFlow(MixedAir) - MixedAir.H2O*18) + enthalpyAir(CooledAir)*(MassFlow(CooledAir) - CooledAir.H2O*18)); %dehumidification energy in kJ/s
% %         HeatedAir = CooledAir;
% %         HeatedAir.T = Tsupply+273.15;
% %         Heating(t)  = (enthalpyAir(HeatedAir)*(MassFlow(HeatedAir) - HeatedAir.H2O*18) - enthalpyAir(CooledAir)*(MassFlow(CooledAir) - CooledAir.H2O*18)); %reheat energy in kJ/s
% %     end   
end
Cooling(abs(Cooling)<1e-10) = 0;
Fan_Power = AirFlow*Build.VariableStruct.FanPower;
end%Ends function BuildingProfile


function Out = loadSched(Build,wd,h_of_y)
sched = fieldnames(Build.Schedule);
for i = 1:1:length(sched)
    s = nnz(Build.Schedule.(sched{i}).Seasons<=h_of_y)+1;% get season
    if isfield(Build.Schedule.(sched{i}),'Ramp')
        Ramp = Build.Schedule.(sched{i}).Ramp;
    else Ramp = 1e-4;
    end
    % get schedule
    if wd == 1% Sunday
        day = 'Sun';
    elseif wd == 7 % Saturday
        day = 'Sat';
    else % Weekday
        day = 'Weekday';
    end
    if iscell(Build.Schedule.(sched{i}).(day))
        Out.(sched{i}) = convertSched(Build.Schedule.(sched{i}).(day){s},Ramp);
    else
        Out.(sched{i}) = convertSched(Build.Schedule.(sched{i}).(day),Ramp);
    end
end

end%Ends function loadSched


function newsched = convertSched(sched,Ramp)
[m,n] = size(sched);
if m==2
    newsched = sched; %this is constant all day, already made 0 hour and 24 hour
else
    newsched = zeros(2*(m-1),n);
    sched(1,2) = sched(2,2);
    newsched(1,:) = sched(1,:);%hour 0
    newsched(end,:) = sched(m,:);%hour 24
    if Ramp<1e-3
        for i = 2:1:m-1 
            newsched(2*i-2,1) = sched(i);
            newsched(2*i-2,2) = sched(i,2);
            newsched(2*i-1,1) = sched(i)+Ramp;
            newsched(2*i-1,2) = sched(i+1,2);
        end
    else 
        for i = 2:1:m-1 %add points in the middle so it can be properly interpolated
            t_bef = sched(i) - sched(i-1);
            t_aft = sched(i+1)-sched(i);
            Ramp2 = min([Ramp, t_aft/2,t_bef/2]);
            newsched(2*i-2,1) = sched(i)-0.5*Ramp2;
            newsched(2*i-2,2) = sched(i,2);
            newsched(2*i-1,1) = sched(i)+0.5*Ramp2;
            newsched(2*i-1,2) = sched(i+1,2);
        end
    end
end

end%Ends function convertSched

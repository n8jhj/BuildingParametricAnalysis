function [Equipment,Lighting,Cooling,Heating,FanPower] = BuildingProfile(Build,Weather,Date)
% This function estimates the energy profile of a building (electric, heating and cooling kW)
% Build is a structure of building parameters
% Weather is an hourly weather profile (dry bulb, wet bulb, and relative humidity)
% Date is a vector of points in datenum format at which you are requesting the electric cooling & heating power
COP_C = 3.65;
COP_H = 3.73;
Fan_Power = .7733; % kW*s/m^3

%% Handle input
% ensure date is an Mx1 vector
[r,c] = size(Date);
if r == 1
    Date = Date';
elseif c ~= 1
    error('Date must be a row or column vector.')
end

%% Rest of function
[Y,Month,D,H,M,S] = datevec(Date);
days = ceil(Date(end) - datenum([Y(1),Month(1),D(1)]));
daysAfter1_1_17 = floor(Date(1)) - datenum([2017,1,1]);
wd = 1 + mod(daysAfter1_1_17,7); %day of the week, sunday is 1, saturday is 7
sd = floor(Date(1)); %start date
nS = length(Date);
dt1 = Date(2) - Date(1);
dt = 86400*(Date - [Date(1)-dt1;Date(1:end-1)]); %duration of each time segment
%calculate minimum air flow rate using density of air: 1.225 kg/m^3
MinFlow = Build.Volume*1.225*(Build.AirChangePerHr/100)*(1/3600); %kg/s of flow

%Specify ramp rate between points in building schedule
Ramp = 1e-4;%ramp period in hrs
%if next point in schedule is shorter than ramp, then ramp shortens to half the gap
Occupancy = zeros(nS,1);
Equipment = zeros(nS,1);
Lighting = zeros(nS,1);
TsetH = zeros(nS,1); %note that the heating setpoint must always be less than the cooling setpoint
TsetC = zeros(nS,1);
Tdb = zeros(nS,1);
RH = zeros(nS,1); %humidity ratio
Cooling = zeros(nS,1);
Heating = zeros(nS,1);
AirFlow = zeros(nS,1);% flow rate in m^3/s
h8761 = (0:1:8760)';
p = 1;
for d = 1:1:days
    h_of_y = 24*(Date(p) - datenum([Y(p),1,1])); %hour since start of year
    %Load schedules for this day
    occ = loadSched(Build.Schedule.occupancy,wd,h_of_y);
    equip = loadSched(Build.Schedule.equipment,wd,h_of_y);
    light = loadSched(Build.Schedule.lighting,wd,h_of_y);
    heat = loadSched(Build.Schedule.heating,wd,h_of_y);
    cool = loadSched(Build.Schedule.cooling,wd,h_of_y);
    %Convert schedule format to something that can be interpolated (add ramps)
    occ = convertSched(occ,Ramp);
    equip = convertSched(equip,Ramp);
    light = convertSched(light,Ramp);
    heat = convertSched(heat,1e-4);%temperature setpoints follow step function
    cool = convertSched(cool,1e-4);
    p2 = p;
    while p2<nS && Date(p2)<sd+d
        p2 = p2+1;
    end
    if Date(p2)>sd+d
        p2 = p2-1;
    end
    Occupancy(p:p2) = Build.Area*Build.occupancy*interp1(occ(:,1),occ(:,2),H(p:p2)+M(p:p2)/60+S(p:p2)/3600); %people in the space
    Equipment(p:p2) = Build.Area*Build.equipment/1000*interp1(equip(:,1),equip(:,2),H(p:p2)+M(p:p2)/60+S(p:p2)/3600);% kW of equipment load
    Lighting(p:p2) = Build.Area*Build.lighting/1000*interp1(light(:,1),light(:,2),H(p:p2)+M(p:p2)/60+S(p:p2)/3600);% kW of lighting load
    TsetH(p:p2) = interp1(heat(:,1),heat(:,2),H(p:p2)+M(p:p2)/60+S(p:p2)/3600);
    TsetC(p:p2) = interp1(cool(:,1),cool(:,2),H(p:p2)+M(p:p2)/60+S(p:p2)/3600);
    
    h_of_y = 24*(Date(p:p2) - datenum([Y(p),1,1])); %hour since start of year
    Tdb(p:p2) = interp1(h8761,[Weather.Tdb(1);Weather.Tdb],h_of_y);
    RH(p:p2) = interp1(h8761,[Weather.RH(1);Weather.RH],h_of_y);
    
    p = p2+1;
    wd = wd+1;
    if wd == 8
        wd = 1;
    end
end
Electric = Equipment + Lighting;
InternalGains = Occupancy*.120 + Equipment + Lighting; %heat from occupants (120 W)
%find ambient dewpoint
P = 101.325; %atmospheric pressure (kPa)
Tdb_K = Tdb+273.15; %Tdb (Kelvin)
satP = exp((-5.8002206e3)./Tdb_K + 1.3914993 - 4.8640239e-2*Tdb_K + 4.1764768e-5*Tdb_K.^2 - 1.4452093e-8*Tdb_K.^3 + 6.5459673*log(Tdb_K))/1000; %saturated water vapor pressure ASHRAE 2013 fundamentals eq. 6 in kPa valid for 0 to 200C
P_H2O = RH/100.*satP;
Tdp = 6.54 + 14.526*log(P_H2O) + 0.7389*log(P_H2O).^2 + 0.09486*log(P_H2O).^3 + 0.4569*(P_H2O).^0.1984; %Dew point from partial pressure of water using ASHRAE 2013 Fundamentals eqn 39 valid from 0C to 93C
Cp_amb = 1.006 + 1.86*(.621945*(P_H2O./(P-P_H2O))); %kJ/kg

%find specific heat of air
% Tset = 22+273.15;
% P = 101.325;
% satP = exp((-5.8002206e3)./Tset + 1.3914993 - 4.8640239e-2*Tset + 4.1764768e-5*Tset.^2 - 1.4452093e-8*Tset.^3 + 6.5459673*log(Tset))/1000; %saturated water vapor pressure ASHRAE 2013 fundamentals eq. 6 in kPa valid for 0 to 200C
% P_H2O = exp(5423*(1/273-1./(273+Build.DPset)))./exp(5423*(1/273-1./(273+Tset))).*satP;%Clausius-Clapeyron equation to calculate relative humidity from dewpoint temperature
% w = (P_H2O/(P-P_H2O));
w = 0.0085;
Cp_build = 1.006 + 1.86*(.621945*w); %kJ/kg
%need to step through time to account for moments with no heating/cooling
%as the building moves between the heat setpoint and the cooling setpoint
if (TsetH(1) - Tdb(1))*Build.Area/Build.Resistance>InternalGains(1)
    Tact = TsetH(1); %initially in heating mode
elseif (TsetC(1) - Tdb(1))*Build.Area/Build.Resistance<InternalGains(1)
    Tact = TsetC(1); %initially in cooling mode
else %initially in equilibrium between the heating and cooling setpoints
    Tact = (TsetH(1) + TsetC(1))/2;
end
for t = 1:1:nS
    Energy2Add = -((Tdb(t) - TsetH(t))*Build.Area/Build.Resistance + InternalGains(t)) - (Tact - TsetH(t))*Build.Capacitance*Build.Area/dt(t); %net energy needed to be added in kJ/s
    if Energy2Add>0
        Tact = TsetH(t);
        Flow = MinFlow;
        Damper = Build.MinDamper; %treat as little ouside air as possible
        Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
        Tset = Energy2Add/(Flow*Cp_Air) + Tact; %temperature of supply air to provide this heating
        Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
        Heating(t) = Cp_Air*(Tset-Tmix)*Flow;
    else
        Heating(t) = 0;
        Energy2Remove = ((Tdb(t) - TsetC(t))*Build.Area/Build.Resistance + InternalGains(t)) + (Tact - TsetC(t))*Build.Capacitance*Build.Area/dt(t); %net energy needed to be removed in kJ/s
        if Energy2Remove>0 %would exceed cooling setpoint without intervention       
            Tact = TsetC(t);
            Tset = Build.ColdAirSet;
            if Tdb(t)<Tact %find economizer position
                if Tdb(t)>Tset
                    Damper = 1;
                else
                    Damper = (Tset - Tact)/(Tdb(t) - Tact);
                end
            else
                Damper = Build.MinDamper; %treat as little ouside air as possible
            end
            Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
            Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
            Flow = Energy2Remove/((Tact-Tset)*Cp_Air); %mass flow of air to provide this cooling
            Cooling(t) = Cp_Air*(Tmix-Tset)*Flow;
        else
%             if Tdb(t)<Tact %open economizer
%                 Damper = 1;
%             else
                Damper = Build.MinDamper;
%             end
            Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
            Tset = Tmix;
            Cooling(t) = 0;
            Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
            Flow = 0;%MinFlow;
            Tact = Tact + ((Tdb(t) - Tact)*Build.Area/Build.Resistance + InternalGains(t) + (Tmix - Tact)*Cp_Air*Flow).*dt(t)/(Build.Capacitance*Build.Area); %net change in temperature
        end
    end
    AirFlow(t) = Flow/1.225;%flow rate in m^3/s
%     %% estimate de-humidification with Cp
%     if Tdp(t)>Build.DPset %must dehumidify incoming air
%         Cp_Air = Damper*Cp_amb(t) + (1-Damper)*Cp_build;
%         Tmix = Damper*Tdb(t) + (1-Damper)*Tact;
%         Cooling(t)  = Flow*Cp_Air*(Tmix - Build.DPset); %dehumidification energy in kJ/s
%         Heating(t)  = Flow*Cp_Air*(Tset - Build.DPset); %dehumidification energy in kJ/s
%     end
%     
%     %% compare to full enthalpy calculations
%     if Tdp(t)>Build.DPset %must dehumidify incoming air
%         %ambient air
%         AmbientAir = makeAir(Tdb(t),RH(t),Damper*Flow,'rel');
%         %recirculated air
%         RecircAir = makeAir(Tact,Build.DPset,(1-Damper)*Flow,'dp');
%         %mixed air
%         MixedAir = MixAir(RecircAir,AmbientAir);
%         CooledAir = MixedAir;
%         CooledAir.T = Build.DPset+273.15; 
%         sat_atDP = makeAir(Build.DPset,100,Flow,'rel');
%         CooledAir.H2O = sat_atDP.H2O; %remove water
%         Cooling(t)  = (-enthalpyAir(MixedAir)*(MassFlow(MixedAir) - MixedAir.H2O*18) + enthalpyAir(CooledAir)*(MassFlow(CooledAir) - CooledAir.H2O*18)); %dehumidification energy in kJ/s
%         HeatedAir = CooledAir;
%         HeatedAir.T = Tset+273.15;
%         Heating(t)  = (enthalpyAir(HeatedAir)*(MassFlow(HeatedAir) - HeatedAir.H2O*18) - enthalpyAir(CooledAir)*(MassFlow(CooledAir) - CooledAir.H2O*18)); %reheat energy in kJ/s
%     end   
end
Cooling(abs(Cooling)<1e-10) = 0;
Heating = Heating/COP_H;% thermal energy added to building divided by heating COP
Cooling = Cooling/COP_C;% thermal energy added to building divided by heating COP
FanPower = Flow*Fan_Power;
end%Ends function BuildingProfile

function loadsched = loadSched(sched,wd,h_of_y)

% get season
Seasons = sched.Seasons;
s = nnz(Seasons<=h_of_y)+1;
% get schedule
if wd == 1
    % Sunday
    if iscell(sched.Sun)
        loadsched = sched.Sun{s};
    else
        loadsched = sched.Sun;
    end
elseif wd == 7
    % Saturday
    if iscell(sched.Sat)
        loadsched = sched.Sat{s};
    else
        loadsched = sched.Sat;
    end
elseif sum(wd == [2,3,4,5,6])
    % Weekday
    if iscell(sched.Weekday)
        loadsched = sched.Weekday{s};
    else
        loadsched = sched.Weekday;
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

function saveradiationdata(weather,DNI,DHI,GHI,name)
%IMPORTRADIATIONDATA Import radiation data from EnergyPlus.
%   formatted = importradiationdata(data)
%   Reformats radiation data from EnergyPlus.

weather.radDirectNormal = DNI;
weather.radDiffuseHorizontal = DHI;
weather.radGlobalHorizontal = GHI;
weather = orderfields(weather);

save(name,'weather')

end

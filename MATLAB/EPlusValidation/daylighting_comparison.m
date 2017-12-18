function daylighting_comparison(building, weather, date)
%DAYLIGHTING_COMPARISON

location = struct(...
    'Latitude', 40, ...
    'Longitude', -105, ...
    'TimeZone', -6 ...
    );
daylightingDaySch = hourlysched(building.Schedule.daylighting.Weekday);
daylightingYearSch = repmat(daylightingDaySch(2:end), 365, 1);

irrad = weather.irradDireNorm;
solarGain = SolarGainThroughWindows(building, location, irrad, date);

x = datetime(date, 'ConvertFrom', 'datenum');
plot(x, daylightingYearSch)
hold on
plot(x, solarGain)
hold off

end

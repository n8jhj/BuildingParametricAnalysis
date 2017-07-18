%% Initialize
zones = {'1A','2A','2B','3A','3B','3B-Coast','3C','4A','4B','4C','5A', ...
    '5B','6A','6B','7A','8A'};

%% Import all weather data to structs in workspace
weather_1A = importWeatherDataToStruct('1A');
weather_2A = importWeatherDataToStruct('2A');
weather_2B = importWeatherDataToStruct('2B');
weather_3A = importWeatherDataToStruct('3A');
weather_3B = importWeatherDataToStruct('3B');
weather_3BCoast = importWeatherDataToStruct('3B-Coast');
weather_3C = importWeatherDataToStruct('3C');
weather_4A = importWeatherDataToStruct('4A');
weather_4B = importWeatherDataToStruct('4B');
weather_4C = importWeatherDataToStruct('4C');
weather_5A = importWeatherDataToStruct('5A');
weather_5B = importWeatherDataToStruct('5B');
weather_6A = importWeatherDataToStruct('6A');
weather_6B = importWeatherDataToStruct('6B');
weather_7A = importWeatherDataToStruct('7A');
weather_8A = importWeatherDataToStruct('8A');

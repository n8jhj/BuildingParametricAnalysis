function building = populatedBuildingStruct(bldgType)
%POPULATEDBUILDINGSTRUCT Building struct containing data about one of the
%DOE prototype buildings.
%   building = populatedBuildingStruct(bldgType)
%   Returns populated building struct. Type of building is specified by
%   BLDGTYPE.

%% Initialize
building = newBldgStruct();

%% Populate
building.Name = bldgType;
building.Area = bldgArea(bldgType);
building.Volume = bldgVol(bldgType);
building.equipment = weightedParam(bldgType,'equipment','floor_area');
building.lighting = weightedParam(bldgType,'lighting','floor_area');
building.occupancy = weightedParam(bldgType,'occupancy','floor_area');
building.Schedule = weightedSchedStruct(bldgType,...
    {'equipment','lighting','occupancy','cooling','heating'},...
    'floor_area');

end

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
building.COP_C = bldgCOPCool(bldgType);
building.COP_H = bldgCOPHeat(bldgType);
building.Fan_Power = bldgFanPower(bldgType);
building.equipment = wtdAvgParam(bldgType,'equipment','floor_area');
building.lighting = wtdAvgParam(bldgType,'lighting','floor_area');
building.occupancy = wtdAvgParam(bldgType,'occupancy','floor_area');
building.Schedule = wtdAvgSchedStruct(bldgType,...
    {'equipment','lighting','occupancy','cooling','heating'},...
    'floor_area');

end

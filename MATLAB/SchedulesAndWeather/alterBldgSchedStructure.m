function bldg = alterBldgSchedStructure(bldg)

fields = {'equipment','lighting','occupancy','cooling','heating'};
for f = 1:1:length(fields)
    fn = fields{f};
    sch = bldg.Schedule.(fn);
    bldg.Schedule.(fn) = struct(...
        'Seasons',{},   ...
        'Weekday',{},   ...
        'Sat',{},       ...
        'Sun',{}        ...
        );
    bldg.Schedule.(fn)(1).Seasons = sch.Seasons;
    bldg.Schedule.(fn)(1).Weekday = sch.Weekday;
    bldg.Schedule.(fn)(1).Sat = sch.Sat;
    bldg.Schedule.(fn)(1).Sun = sch.Sun;
end

end

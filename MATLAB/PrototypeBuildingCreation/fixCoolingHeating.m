function bldg = fixCoolingHeating(bldg)
fields = {'Weekday','Sat','Sun'};
for f = 1:1:length(fields)
    fn = fields{f};
    bldg.Schedule.(fn).cooling = bldg.Schedule.(fn).cool;
    bldg.Schedule.(fn) = rmfield(bldg.Schedule.(fn),'cool');
    bldg.Schedule.(fn).heating = bldg.Schedule.(fn).heat;
    bldg.Schedule.(fn) = rmfield(bldg.Schedule.(fn),'heat');
end
end

function bldg = alterBldgSchedStructure(bldg)

fields = {'equipment','lighting','occupancy','cooling','heating'};
for f = 1:1:length(fields)
    fn = fields{f};
    schNames = fieldnames(bldg.Schedule.(fn));
    for i = 1:1:length(schNames)
        sn = schNames{i};
        if ~iscell(bldg.Schedule.(fn).(sn))
            bldg.Schedule.(fn).(sn) = {bldg.Schedule.(fn).(sn)};
        end
    end
end

end

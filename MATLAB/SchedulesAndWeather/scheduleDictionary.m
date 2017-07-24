function sch = scheduleDictionary(name)
%SCHEDULEDICTIONARY Dictionary for EnergyPlus schedules.
%   sch = scheduleDictionary(name)
%   Returns schedule SCH corresponding with key NAME, which is a string.

switch name
    case 'HotelSmall BLDG_LIGHT_CORRIDOR_SCH'
        sch = [...
            
            ];
    otherwise
        error('Input ''name'' not recognized: %s', name)
end

end

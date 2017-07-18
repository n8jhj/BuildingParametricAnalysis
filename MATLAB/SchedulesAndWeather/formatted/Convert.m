names = {'Hospital';'LargeOffice';'MediumOffice';'SmallOffice';};
for i = 1:1:length(names)
    load(names{i});
    building.Area = eval(strcat(names{i},'.area{1}'))/10.76;%convert ft^2 to m^2
    building.equipment = eval(strcat(names{i},'.equipment.value{1}'));
    building.lighting = eval(strcat(names{i},'.lighting.value{1}'));
    building.occupancy = eval(strcat(names{i},'.occupancy.value{1}'));
    building.Schedule.Seasons = 8760; % a vector of hour of the year where the season switches. Each season is its own cell in ____.equipment
    if isfield(eval(strcat(names{i},'.equipment')),'sat')
        building.Schedule.Weekday.equipment{1} = [0, eval(strcat(names{i},'.equipment.weekday(end,2)')); eval(strcat(names{i},'.equipment.weekday'))];
        building.Schedule.Sat.equipment{1} = [0, eval(strcat(names{i},'.equipment.sat(end,2)')); eval(strcat(names{i},'.equipment.sat'))];
        building.Schedule.Sun.equipment{1} = [0, eval(strcat(names{i},'.equipment.sun(end,2)')); eval(strcat(names{i},'.equipment.sun'))];
    elseif isfield(eval(strcat(names{i},'.equipment')),'weekend')
        building.Schedule.Weekday.equipment{1} = [0, eval(strcat(names{i},'.equipment.weekday(end,2)')); eval(strcat(names{i},'.equipment.weekday'))];
        building.Schedule.Sat.equipment{1} = [0, eval(strcat(names{i},'.equipment.weekend(end,2)')); eval(strcat(names{i},'.equipment.weekend'))];
        building.Schedule.Sun.equipment{1} = [0, eval(strcat(names{i},'.equipment.weekend(end,2)')); eval(strcat(names{i},'.equipment.weekend'))];
    end
    if isfield(eval(strcat(names{i},'.lighting')),'sat')
        building.Schedule.Weekday.lighting{1} = [0, eval(strcat(names{i},'.lighting.weekday(end,2)')); eval(strcat(names{i},'.lighting.weekday'))];
        building.Schedule.Sat.lighting{1} = [0, eval(strcat(names{i},'.lighting.sat(end,2)')); eval(strcat(names{i},'.lighting.sat'))];
        building.Schedule.Sun.lighting{1} = [0, eval(strcat(names{i},'.lighting.sun(end,2)')); eval(strcat(names{i},'.lighting.sun'))];
    elseif isfield(eval(strcat(names{i},'.lighting')),'weekend')
        building.Schedule.Weekday.lighting{1} = [0, eval(strcat(names{i},'.lighting.weekday(end,2)')); eval(strcat(names{i},'.lighting.weekday'))];
        building.Schedule.Sat.lighting{1} = [0, eval(strcat(names{i},'.lighting.weekend(end,2)')); eval(strcat(names{i},'.lighting.weekend'))];
        building.Schedule.Sun.lighting{1} = [0, eval(strcat(names{i},'.lighting.weekend(end,2)')); eval(strcat(names{i},'.lighting.weekend'))];
    end
    if isfield(eval(strcat(names{i},'.occupancy')),'sat')
        building.Schedule.Weekday.occupancy{1} = [0, eval(strcat(names{i},'.occupancy.weekday(end,2)')); eval(strcat(names{i},'.occupancy.weekday'))];
        building.Schedule.Sat.occupancy{1} = [0, eval(strcat(names{i},'.occupancy.sat(end,2)')); eval(strcat(names{i},'.occupancy.sat'))];
        building.Schedule.Sun.occupancy{1} = [0, eval(strcat(names{i},'.occupancy.sun(end,2)')); eval(strcat(names{i},'.occupancy.sun'))];
    elseif isfield(eval(strcat(names{i},'.occupancy')),'weekend')
        building.Schedule.Weekday.occupancy{1} = [0, eval(strcat(names{i},'.occupancy.weekday(end,2)')); eval(strcat(names{i},'.occupancy.weekday'))];
        building.Schedule.Sat.occupancy{1} = [0, eval(strcat(names{i},'.occupancy.weekend(end,2)')); eval(strcat(names{i},'.occupancy.weekend'))];
        building.Schedule.Sun.occupancy{1} = [0, eval(strcat(names{i},'.occupancy.weekend(end,2)')); eval(strcat(names{i},'.occupancy.weekend'))];
    end
    if isfield(eval(strcat(names{i},'.heat_setpt')),'sat')
        building.Schedule.Weekday.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.weekday(end,2)')); eval(strcat(names{i},'.heat_setpt.weekday'))];
        building.Schedule.Sat.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.sat(end,2)')); eval(strcat(names{i},'.heat_setpt.sat'))];
        building.Schedule.Sun.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.sun(end,2)')); eval(strcat(names{i},'.heat_setpt.sun'))];
    elseif isfield(eval(strcat(names{i},'.heat_setpt')),'weekend')
        building.Schedule.Weekday.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.weekday(end,2)')); eval(strcat(names{i},'.heat_setpt.weekday'))];
        building.Schedule.Sat.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.weekend(end,2)')); eval(strcat(names{i},'.heat_setpt.weekend'))];
        building.Schedule.Sun.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.weekend(end,2)')); eval(strcat(names{i},'.heat_setpt.weekend'))];
    elseif isfield(eval(strcat(names{i},'.heat_setpt')),'whole_week')
        building.Schedule.Weekday.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.whole_week(end,2)')); eval(strcat(names{i},'.heat_setpt.whole_week'))];
        building.Schedule.Sat.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.whole_week(end,2)')); eval(strcat(names{i},'.heat_setpt.whole_week'))];
        building.Schedule.Sun.heat{1} = [0, eval(strcat(names{i},'.heat_setpt.whole_week(end,2)')); eval(strcat(names{i},'.heat_setpt.whole_week'))];
    end
    if isfield(eval(strcat(names{i},'.cool_setpt')),'sat')
        building.Schedule.Weekday.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.weekday(end,2)')); eval(strcat(names{i},'.cool_setpt.weekday'))];
        building.Schedule.Sat.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.sat(end,2)')); eval(strcat(names{i},'.cool_setpt.sat'))];
        building.Schedule.Sun.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.sun(end,2)')); eval(strcat(names{i},'.cool_setpt.sun'))];
    elseif isfield(eval(strcat(names{i},'.cool_setpt')),'weekend')
        building.Schedule.Weekday.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.weekday(end,2)')); eval(strcat(names{i},'.cool_setpt.weekday'))];
        building.Schedule.Sat.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.weekend(end,2)')); eval(strcat(names{i},'.cool_setpt.weekend'))];
        building.Schedule.Sun.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.weekend(end,2)')); eval(strcat(names{i},'.cool_setpt.weekend'))];
    elseif isfield(eval(strcat(names{i},'.cool_setpt')),'whole_week')
        building.Schedule.Weekday.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.whole_week(end,2)')); eval(strcat(names{i},'.cool_setpt.whole_week'))];
        building.Schedule.Sat.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.whole_week(end,2)')); eval(strcat(names{i},'.cool_setpt.whole_week'))];
        building.Schedule.Sun.cooling{1} = [0, eval(strcat(names{i},'.cool_setpt.whole_week(end,2)')); eval(strcat(names{i},'.cool_setpt.whole_week'))];
    end
    save(names{i},'building')
end
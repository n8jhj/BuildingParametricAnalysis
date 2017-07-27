function [ssns,wkdy,sat,sun] = spaceSchedules(sch_names)
%SPACESCHEDULES List of seasons numbers and cell array of all schedules
%corresponding to input schedule names.
%   [ssns,wkdy,sat,sun] = spaceSchedules(sch_names)
%   Returns a list of season numbers SSNS as well as three cell arrays of
%   schedule cell arrays. Each element of each of the three cell arrays
%   corresponds to one of the input schedule names. SCH_NAMES should be a
%   cell array of strings.

%% Initialize
s_len = length(sch_names);
sch = scheduleDictionary(sch_names{1});
ssns = sch.Seasons;
wkdy = cell(s_len,1);
sat = cell(s_len,1);
sun = cell(s_len,1);

%% Get schedules from schedule dictionary
for i = 1:1:length(sch_names)
    sch = scheduleDictionary(sch_names{i});
    if sch.Seasons == ssns || isnan(sch.Seasons)
        wkdy{i} = sch.Weekday;
        sat{i} = sch.Sat;
        sun{i} = sch.Sun;
    else
        error(strcat('This function needs to be updated to handle', ...
            ' different seasons within a load type.'))
    end
end

end

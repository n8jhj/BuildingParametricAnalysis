function col_scheds = collapseScheds(scheds)
%COLLAPSESCHEDS List of "until-value" pairs for the input hourly schedule.
%   col_scheds = collapseScheds(scheds)
%   Returns the collapsed schedule form of input SCHEDS. Input SCHEDS
%   should be either a list containing 24 values, one for each hour of the
%   day, or a cell array of such lists.

%% Handle input
nocell = false;
if ~iscell(scheds)
    nocell = true;
    scheds = {scheds};
end

%% Get return schedules
% initialize
col_scheds = cell(size(scheds));
% for each input schedule
for s = 1:1:length(scheds)
    %% Initialize temporary structures
    col_temp = zeros(1,2);
    sch_temp = scheds{s};
    
    %% Populate
    s_len = length(sch_temp);
    n_sw = 1; % number of switches
    last_val = NaN;
    for i = 1:1:s_len
        if sch_temp(i) ~= last_val
            col_temp(n_sw,2) = sch_temp(i);
            if n_sw~=1
                col_temp(n_sw-1,1) = i-1;
            end
            last_val = sch_temp(i);
            n_sw = n_sw + 1;
        end
        if i==s_len
            col_temp(n_sw-1,1) = i;
        end
    end
    col_scheds{s} = col_temp;
end

%% Prepare output
if nocell
    col_scheds = col_scheds{1};
end

end

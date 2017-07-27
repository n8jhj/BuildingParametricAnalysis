function exp_scheds = expandScheds(scheds)
%EXPANDSCHEDS List of hourly values for the input schedule.
%   exp_scheds = expandScheds(scheds)
%   Returns the hourly schedule form of input SCHEDS. Input SCHEDS should
%   be either an Mx2 matrix of "until-value" pairs or a cell array of such
%   matrices. E.g. [8,0; 17,1; 24,0] is 0 until 0800; 1 until 1700; 0 until
%   2400.

%% Handle input
nocell = false;
if ~iscell(scheds)
    nocell = true;
    scheds = {scheds};
end

%% Get return schedules
% initialize
exp_scheds = cell(size(scheds));
% for each input schedule
for s = 1:1:length(scheds)
    %% Initialize temporary structures
    exp_temp = zeros(24,1);
    sch_temp = scheds{s};
    
    %% Populate
    [s_len,~] = size(sch_temp);
    hr = 1;
    for i = 1:1:s_len
        while hr <= sch_temp(i,1)
            exp_temp(hr) = sch_temp(i,2);
            hr = hr+1;
        end
    end
    exp_scheds{s} = exp_temp;
end

%% Prepare output
if nocell
    exp_scheds = exp_scheds{1};
end

end

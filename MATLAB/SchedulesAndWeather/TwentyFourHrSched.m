function fullSched = TwentyFourHrSched(sched)
%TWENTYFOURHRSCHED List of hourly values for the input schedule.
%   fullSched = TwentyFourHrSched(sched)
%   Returns the full schedule form of input SCHED. Input SCHED should be
%   either an Nx2 matrix of "until-value" pairs or a cell array of such
%   matrices. E.g. [8,0; 17,1; 24,0] is 0 until 0800; 1 until 1700; 0 until
%   2400.

%% Handle input
if ~iscell(sched)
    sched = {sched};
end

%% Get return schedules
% initialize
fullSched = cell(size(sched));
% for each input schedule
for s = 1:1:length(sched)
    %% Initialize
    fullTemp = zeros(24,1);
    schTemp = sched{s};

    %% Populate
    [sLen,~] = size(schTemp);
    hr = 1;
    for i = 1:1:sLen
        while hr <= schTemp(i,1)
            fullTemp(hr) = schTemp(i,2);
            hr = hr+1;
        end
    end
    fullSched{s} = fullTemp;

end

end

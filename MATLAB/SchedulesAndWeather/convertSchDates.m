function bldg = convertSchDates(bldg,newStyle)
%CONVERTSCHDATES Convert prototype building struct to a prototype building
%with a different way of expressing schedule dates.
%   bldg = convertSchDates(bldg,newStyle)
%   Converts building to the new schedule dates style NEWSTYLE.

%% Check input
assert(isfield(bldg,'equipment'), ...
    'Input building must contain equipment field.')
assert(isfield(bldg.equipment,'sch_dates'), ...
    'Input building must contain sch_dates field.')

%% Determine the old style
sz = size(bldg.equipment.sch_dates);
if sz(2) == 4
    oldStyle = 'date_pair';
else
    oldStyle = 'long_list';
end
if strcmp(oldStyle,newStyle)
    return
end

%% Get building fields
bldgFds = fieldnames(bldg);
fLen = length(bldgFds);

%% Get new style field
yr = 2017; % 2017 begins on a Sunday and is not a leap year
for f = 1:1:fLen
    fn = bldgFds{f};
    if ~strcmp(fn,'area')
        switch newStyle
            case 'long_list'
                bldg = convertToLongList(bldg,fn,yr);
            case 'date_pair'
                % pass for now
            otherwise
                error('Input newStyle not recognized.')
        end
    end
end

end


%% Convert to long list style
function bldg = convertToLongList(bldg,fn,yr)
%% Initialize long_list
long_list = zeros(1,365);
indStart = 1;
%% Fill long_list
datesMat = bldg.(fn).sch_dates;
szdtm = size(datesMat);
sLen = szdtm(1);
% initialize schedule count
cnt = 0;
% for each section of the year
for s = 1:1:sLen
    % get number of schedule types
    sField = bldg.(fn).(strcat('sch',num2str(s)));
    % get this section's field names
    sFdNms = fieldnames(sField);
    % get number of days in section
    dnLo = datenum(yr,datesMat(s,1),datesMat(s,2));
    dnHi = datenum(yr,datesMat(s,3),datesMat(s,4));
    nDays = dnHi - dnLo;
    indEnd = indStart + nDays;
    dNums = dnLo:1:dnHi;
    % for each index in the proper range of long_list
    for i = indStart:1:indEnd
        relSNum = schNum(weekday(dNums(i)),sField);
        newSNum = relSNum + cnt;
        % assign section values to long_list
        long_list(i) = newSNum;
        % update building field
        sStr = strcat('s',newSNum);
        if ~isfield(bldg.(fn),sStr)
            bldg.(fn).(sStr) = ...
                bldg.(fn).(strcat('sch',s)).(sFdNms{relSNum});
        end
    end
    % update indStart and cnt
    indStart = indEnd + 1;
    cnt = cnt + length(fieldnames(sField));
end
%% Apply results to input building
bldg.(fn).sch_dates = long_list;
% for each day of the year
for d = 1:1:length(long_list)
    long_list(d) = schNum(long_list(d));
end
end


%% Determine the schedule number to be used for long_list
function snum = schNum(weekday,sField)
switch weekday
    case 1 % Sunday
        if isfield(sField,'sun')
            snum = find(strcmp(fieldnames(sField),'sun'));
        elseif isfield(sField,'weekend')
            snum = find(strcmp(fieldnames(sField),'weekend'));
        else
            error('Neither ''sun'' nor ''weekend'' found.')
        end
    case 7 % Saturday
        if isfield(sField,'sat')
            snum = find(strcmp(fieldnames(sField),'sat'));
        elseif isfield(sField,'weekend')
            snum = find(strcmp(fieldnames(sField),'weekend'));
        else
            error('Neither ''sat'' nor ''weekend'' found.')
        end
    case [2,3,4,5,6] % weekday
        if isfield(sField,'weekday')
            snum = find(strcmp(fieldnames(sField),'weekday'));
        else
            error('''weekday'' not found.')
        end
    otherwise
        error('Input weekday should be in range 1 to 7.')
end
end

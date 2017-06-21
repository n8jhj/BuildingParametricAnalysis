function buildings = addDaysToBuildings(buildings)
%ADDDAYSTOBUILDINGS Partition data of input buildings into days and add
%them to the buildings struct.
%   buildings = addDaysToBuildings(buildings)
%   Returns the input struct BUILDINGS with a new field called 'days',
%   which is the data partitioned into days.

%% Add field 'days' to each building
for i = 1:1:length(buildings)
    [days,~] = partitionByDays(buildings(i).data);
    buildings(i).days = days;
end

end
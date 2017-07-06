function buildings = addAvgNomRngToBuildings(buildings)
%ADDAVGNOMRNGTOBUILDINGS Get mean nominal range and add as a field to input
%struct.
%   buildings = addAvgNomRngToBuildings(buildings)
%   Returns input struct BUILDINGS with new field 'avgNomRng' for each
%   building.

%% Check for field 'nomRng'
assert(isfield(buildings(1).days, 'nomRng'), ...
    strcat('Input buildings must contain field nomRng within field', ...
    ' days. Run addNominalRangesToBuildings first.'))

%% Add 'avgNomRng' fields to each building
bLen = length(buildings);
% for each building
for b = 1:1:bLen
    % get field names
    dLen = length(buildings(b).days);
    d = 1;
    empty = true;
    while empty && d <= dLen
        if ~isempty(buildings(b).days(d).nomRng)
            fdNames = fieldnames(buildings(b).days(d).nomRng.rng);
            fLen = length(fdNames);
            empty = false;
        end
        d = d + 1;
    end
    % for each field
    for f = 1:1:fLen
        fn = fdNames{f};
        nomRngs = NaN(dLen,1);
        % for each day
        for d = 1:1:dLen
            try
                % get nominal ranges
                nomRngs(d) = [buildings(b).days(d).nomRng.rng.(fn)];
            catch ME
                fprintf('Error at building %i, day %i\n', b, d)
                rethrow(ME)
            end
        end
        % average nomRng values
        buildings(b).avgNomRng.(fn) = nanmean(nomRngs);
    end
end

end

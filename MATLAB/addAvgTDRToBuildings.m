function buildings = addAvgTDRToBuildings(buildings)
%ADDAVGTDRTOBUILDINGS Get mean TDR and add as a field to input struct.
%   buildings = addAvgTDRToBuildings(buildings)
%   Returns input struct BUILDINGS with new fields 'avgTdrEn' and
%   'avgTdrDe' for each building.

%% Check for fields 'tdrEn' and 'tdrDe'
fdNames = fieldnames(buildings(1).days);
fieldsStr = strcat(fdNames{:});
assert(~isempty(strfind(fieldsStr, 'tdr_')), ...
    strcat('Input buildings must contain at least one TDR field', ...
    ' within field days. Run addTDRsToBuildings first.'))

%% Add 'avgTdr' fields to each building
bLen = length(buildings);
% for each building
for b = 1:1:bLen
    % get field names within field 'tdr'
    dLen = length(buildings(b).days);
    d = 1;
    empty = true;
    while empty && d <= dLen
        if ~isempty(buildings(b).days(d).tdr)
            fdNames = fieldnames(buildings(b).days(d).tdr);
            fLen = length(fdNames);
            empty = false;
        end
        d = d + 1;
    end
    % for each field
    for f = 1:1:fLen
        fn = fdNames{f};
        tdrs = NaN(dLen,1);
        % for each day
        for d = 1:1:dLen
            % get TDRs
            tdrs = buildings(b).days(d).tdr.(fn);
        end
        % get rid of any Inf values
        tdrs(isinf(tdrs)) = NaN;
        % average TDRs
        buildings(b).avgTdr.(fn) = nanmean(tdrs);
    end
end

end

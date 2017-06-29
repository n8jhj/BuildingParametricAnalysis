function buildings = addNominalRangesToBuildings(buildings)
%ADDNOMINALRANGESTOBUILDINGS

bLen = length(buildings);
% for each building
for b = 1:1:bLen
    nDays = length(buildings(b).days);
    fdNames = fieldnames(buildings(b).days);
    % for each day
    for d = 1:1:nDays
        try
            % for each field
            for f = 1:1:length(fdNames)
                fn = fdNames{f};
                if (strcmp(fn,'totFacEn') || strcmp(fn,'totFacDe')) ...
                        && ~isempty(buildings(b).days(d).timestamp)
                    [buildings(b).days(d).nomRng.(fn),~] = ...
                        minPercentRange(buildings(b).days(d).(fn), 0.95);
                end
            end
        catch ME
            fprintf('Error at building %i, day %i\n', b, d)
            rethrow(ME)
        end
    end
end

end

function buildings = addPeakOutliersToBuildings(buildings)
%ADDPEAKOUTLIERSTOBUILDINGS Add peak outliers (low and high) for each day
%of each building.
%   building = addPeakOutliersToBuildings(buildings)
%   Adds field 'pkOtlrs' to each day of each building. The peak outliers are
%   the absolute minimum minus the 

%% Add field 'pkOtlrs' to each day for each building
bLen = length(buildings);
% for each building
for b = 1:1:bLen
    try
        fdNames = fieldnames(buildings(b).data);
        fLen = length(fdNames);
        % for each field
        for f = 1:1:fLen
            % add 'pkOtlrs' to all days
            fn = fdNames{f};
            if strcmp(fn, 'totFacEn') || strcmp(fn, 'totFacDe')
                buildings(b).days = ...
                    addPeakOutliersToDays(buildings(b).days, fn);
            end
        end
        buildings(b).days = addPeakOutliersToDays(buildings(b).days,'totFacEn');
    catch ME
        fprintf('Error at building %i\n', b)
        rethrow(ME)
    end
end

end

function days = addPeakOutliersToDays(days, field)
%ADDPEAKOUTLIERSTODAYS Add peak outliers to each day in input DAYS for the
%input FIELD specified.
%   days = addPeakOutliersToDays(days, field)
%   Returns DAYS with a subfield FIELD of 'pkOtlrs' added.

%% Check for existence of field 'vals' within 'nomRng'
assert(isfield(days.nomRng.vals), ...
    strcat('Field ''vals'' within field ''nomRng'' required.', ...
    ' Run addNominalRangesToBuildings first.'))

%% Add peak outliers to each day
dLen = length(days);
% for each day
for d = 1:1:dLen
    days.pkOtlrs
end

end

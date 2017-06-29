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
for i = 1:1:length(buildings)
    % get TDRs
    tdrsEn = [buildings(i).days.tdr_totFacEn].';
    tdrsDe = [buildings(i).days.tdr_totFacDe].';
    
    % get rid of Inf values
    tdrsEn(isinf(tdrsEn)) = NaN;
    tdrsDe(isinf(tdrsDe)) = NaN;
    
    % average TDRs
    buildings(i).avgTdr_totFacEn = nanmean(tdrsEn);
    buildings(i).avgTdr_totFacDe = nanmean(tdrsDe);
end

end
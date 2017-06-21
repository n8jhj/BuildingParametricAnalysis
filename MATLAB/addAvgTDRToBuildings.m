function buildings = addAvgTDRToBuildings(buildings)
%ADDAVGTDRTOBUILDINGS Get mean TDR and add as a field to input struct.
%   buildings = addAvgTDRToBuildings(buildings)
%   Returns input struct BUILDINGS with new fields 'avgTdrEn' and
%   'avgTdrDe' for each building.

%% Check for fields 'tdrEn' and 'tdrDe'
assert(isfield(buildings(1).days, 'tdrEn') && ...
    isfield(buildings(1).days, 'tdrDe'), ...
    strcat('Input buildings must contain fields ''tdrEn'' and', ...
     ' ''tdrDe''. Run addTDRsToBuildings first.'))

%% Add fields 'avgTdrEn' and 'avgTdrDe' to each building
for i = 1:1:length(buildings)
    % get TDRs
    tdrsEn = [buildings(i).days.tdrEn].';
    tdrsDe = [buildings(i).days.tdrDe].';
    % get rid of Inf values
    tdrsEn(isinf(tdrsEn)) = NaN;
    tdrsDe(isinf(tdrsDe)) = NaN;
    % average TDRs
    buildings(i).avgTdrEn = nanmean(tdrsEn);
    buildings(i).avgTdrDe = nanmean(tdrsDe);
end

end
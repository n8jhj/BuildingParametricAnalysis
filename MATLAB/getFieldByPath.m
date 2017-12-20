function field = getFieldByPath(inStruct, path)
%GETFIELDBYPATH Get field of struct specified by path.
% field = GETFIELDBYPATH(inStruct, path)
%   INSTRUCT is the input struct to get the field from. PATH is the path to
%   that field, a cell array of strings and numbers corresponding to field
%   names and indices.
%
% Example:
%   field = getFieldByPath(buildings(2), {'days',7,'tdr','totFacEn'});
%   Gets field buildings(2).days(7).tdr.totFacEn

%% Loop through levels of inStruct, getting the desired field
field = inStruct;
pLen = length(path);
for p = 1:1:pLen
    if isnumeric(path{p})
        field = field(path{p});
    else
        field = field.(path{p});
    end
end

end

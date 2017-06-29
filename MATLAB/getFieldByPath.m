function field = getFieldByPath(inStruct, path)
%GETFIELDBYPATH Get field of struct specified by path.
%   field = getFieldByPath(inStruct, path)
%   INSTRUCT is the input struct to get the field from. PATH is the path to
%   that field, a cell array of alternating strings and numbers
%   corresponding to field names and indices. First element in PATH must be
%   a string.
%
% Example:
%   field = getFieldByPath(buildings, {'mads',2,'totFacEn'})

%% Loop through levels of inStruct, getting the desired field
field = inStruct;
pLen = length(path);
maxLv = ceil(pLen/2);
for lv = 1 : 1 : maxLv
    if lv < maxLv
        field = field.(path{2*lv-1})(path{2*lv});
    else
        if mod(pLen/2, 2)
            % odd
            field = field.(path{2*lv-1});
        else
            % even
            field = field.(path{2*lv-1})(path{2*lv});
        end
        
    end
end

end

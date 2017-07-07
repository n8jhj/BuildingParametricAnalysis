function fdNames = fieldNamesWithinField(days,field)
%FIELDNAMESWITHINFIELD Cell array of field names within the given field of
%DAYS.
%   fdNames = fieldNamesWithinField(days,field)
%   Finds field names within field FIELD of input struct DAYS and returns
%   them in a cell array. Input FIELD should be a cell array of strings
%   specifying the path to the desired field.

%% Loop until a non-empty day is found and return its field names
dLen = length(days);
d = 1;
empty = true;
while empty && d <= dLen
    fdStruct = getFieldByPath(days(d),field);
    if ~isempty(fdStruct)
        fdNames = fieldnames(fdStruct);
        empty = false;
    end
    d = d + 1;    
end

%% Make sure a set of field names was found
assert(~empty, 'All daily elements in field %s are empty', field)

end

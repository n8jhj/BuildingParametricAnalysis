function subset = getSubset(inStruct, inds)
%GETSUBSET Return subset at specified indices of input struct.
%   subset = getSubset(inStruct,inds)
%   INSTRUCT is a struct. INDS is a list of indices.

for i = 1:1:length(inds)
    subset(i) = inStruct(inds(i));
end

end

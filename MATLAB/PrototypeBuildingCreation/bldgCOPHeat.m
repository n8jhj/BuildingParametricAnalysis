function coph = bldgCOPHeat(b_type)
%BLDGCOPHEAT Heating COP parameter for DOE prototype building.
%   coph = bldgCOPHeat(b_type)
%   Returns the COP of the building's heating coil in W/W.

switch b_type
    case 'SmallOffice'
        coph = 3.738196;
    otherwise
        error('Building type %s not recognized.', b_type)
end

end

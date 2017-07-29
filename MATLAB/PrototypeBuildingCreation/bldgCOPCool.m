function copc = bldgCOPCool(b_type)
%BLDGCOPCOOL Cooling COP parameter for DOE prototype building.
%   copc = bldgCOPCool(b_type)
%   Returns the COP of the building's cooling coil in W/W.

switch b_type
    case 'SmallOffice'
        copc = 3.6504;
    otherwise
        error('Building type %s not recognized.', b_type)
end

end

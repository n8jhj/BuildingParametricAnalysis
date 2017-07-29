function fpow = bldgFanPower(b_type)
%BLDGFANPOWER Fan power parameter for DOE prototype building.
%   fpow = bldgFanPower(b_type)
%   Returns the fan power for the input building B_TYPE in kW/(m^3/s).

switch b_type
    case 'SmallOffice'
        fpow = 0.7733;
    otherwise
        error('Building type %s not recognized.', b_type)
end

end

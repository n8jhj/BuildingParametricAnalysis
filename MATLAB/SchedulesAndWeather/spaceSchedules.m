function sData = spaceSchedules(bType,param)
%SPACESCHEDULES Schedule for the given parameter for the given building type.
%   sData = spaceSchedules(bType,param)
%   Returns a cell array of alternating string-list pairs, with each pair
%   containing the name and times and values of a certain schedule.

switch bType
    case 'SmallHotel'
        switch param
            case 'cooling'
                sData = {
                    'Corridor',         'HotelSmall CommonArea_ClgSP_Sch';
                    'Corridor4',        'HotelSmall CommonArea_ClgSP_Sch';
                    'Elec/MechRoom',    '';
                    'ElevatorCore',     '';
                    'ElevatorCore4',    '';
                    'Exercise',         'HotelSmall CommonArea_ClgSP_Sch';
                    'GuestLounge',      'HotelSmall CommonArea_ClgSP_Sch';
                    'GuestRoom123Occ',  'HotelSmall Adva_OccGuestRoom_ClgSP_Sch';
                    'GuestRoom123Vac',  'HotelSmall VacGuestRoom_ClgSP_Sch';
                    'GuestRoom4Occ',    'HotelSmall Adva_OccGuestRoom_ClgSP_Sch';
                    'GuestRoom4Vac',    'HotelSmall VacGuestRoom_ClgSP_Sch';
                    'Laundry',          'HotelSmall CommonArea_ClgSP_Sch';
                    'Mechanical',       'SmallHotel UnitHeater ClgSP Sch';
                    'Meeting',          'HotelSmall CommonArea_ClgSP_Sch';
                    'Office',           'HotelSmall CommonArea_ClgSP_Sch';
                    'PublicRestroom',   'HotelSmall CommonArea_ClgSP_Sch';
                    'StaffLounge',      'HotelSmall CommonArea_ClgSP_Sch';
                    'Stair',            'SmallHotel UnitHeater ClgSP Sch';
                    'Stair4',           'SmallHotel UnitHeater ClgSP Sch';
                    'Storage',          'SmallHotel UnitHeater ClgSP Sch';
                    'Storage4Front',    'SmallHotel UnitHeater ClgSP Sch';
                    'Storage4Rear',     'SmallHotel UnitHeater ClgSP Sch';
                    };
            case 'equipment'
                sData = {
                    'Corridor',         '';
                    'Corridor4',        '';
                    'Elec/MechRoom',    'HotelSmall BLDG_ELEVATORS';
                    'ElevatorCore',     '';
                    'ElevatorCore4',    '';
                    'Exercise',         'HotelSmall ExerciseCenter_Eqp_Sch';
                    'GuestLounge',      'HotelSmall Lobby_Eqp_Sch';
                    'GuestRoom123Occ',  'HotelSmall GuestRoom_Eqp_Sch_Base';
                    'GuestRoom123Vac',  'HotelSmall AlwaysOff';
                    'GuestRoom4Occ',    'HotelSmall GuestRoom_Eqp_Sch_Base';
                    'GuestRoom4Vac',    'HotelSmall AlwaysOff';
                    'Laundry',          'HotelSmall LaundryRoom_Eqp_Elec_Sch';
                    'Mechanical',       '';
                    'Meeting',          'HotelSmall MeetingRoom_Eqp_Sch';
                    'Office',           'HotelSmall OFF_EQUIP_SCH';
                    'PublicRestroom',   '';
                    'StaffLounge',      'HotelSmall EmployeeLounge_Eqp_Sch';
                    'Stair',            '';
                    'Stair4',           '';
                    'Storage',          '';
                    'Storage4Front',    '';
                    'Storage4Rear',     '';
                    };
            case 'heating'
                sData = {
                    'Corridor',         'HotelSmall CommonArea_HtgSP_Sch';
                    'Corridor4',        'HotelSmall CommonArea_HtgSP_Sch';
                    'Elec/MechRoom',    '';
                    'ElevatorCore',     '';
                    'ElevatorCore4',    '';
                    'Exercise',         'HotelSmall CommonArea_HtgSP_Sch';
                    'GuestLounge',      'HotelSmall CommonArea_HtgSP_Sch';
                    'GuestRoom123Occ',  'HotelSmall Adva_OccGuestRoom_HtgSP_Sch';
                    'GuestRoom123Vac',  'HotelSmall VacGuestRoom_HtgSP_Sch';
                    'GuestRoom4Occ',    'HotelSmall Adva_OccGuestRoom_HtgSP_Sch';
                    'GuestRoom4Vac',    'HotelSmall VacGuestRoom_HtgSP_Sch';
                    'Laundry',          'HotelSmall CommonArea_HtgSP_Sch';
                    'Mechanical',       'HotelSmall SemiHeated_HtgSP_Sch';
                    'Meeting',          'HotelSmall CommonArea_HtgSP_Sch';
                    'Office',           'HotelSmall CommonArea_HtgSP_Sch';
                    'PublicRestroom',   'HotelSmall CommonArea_HtgSP_Sch';
                    'StaffLounge',      'HotelSmall CommonArea_HtgSP_Sch';
                    'Stair',            'HotelSmall SemiHeated_HtgSP_Sch';
                    'Stair4',           'HotelSmall SemiHeated_HtgSP_Sch';
                    'Storage',          'HotelSmall SemiHeated_HtgSP_Sch';
                    'Storage4Front',    'HotelSmall SemiHeated_HtgSP_Sch';
                    'Storage4Rear',     'HotelSmall SemiHeated_HtgSP_Sch';
                    };
            case 'lighting'
                sData = {
                    'Corridor',         'HotelSmall BLDG_LIGHT_CORRIDOR_SCH';
                    'Corridor4',        'HotelSmall BLDG_LIGHT_CORRIDOR_SCH';
                    'Elec/MechRoom',    '';	
                    'ElevatorCore',     '';
                    'ElevatorCore4',    '';
                    'Exercise',         'HotelSmall BLDG_LIGHT_EXERCENTER_SCH';
                    'GuestLounge',      'HotelSmall BLDG_LIGHT_FRONTLOUNGE_SCH';
                    'GuestRoom123Occ',  'HotelSmall BLDG_LIGHT_GUESTROOM_SCH_2010';	
                    'GuestRoom123Vac',  'HotelSmall AlwaysOff';
                    'GuestRoom4Occ',    'HotelSmall BLDG_LIGHT_GUESTROOM_SCH_2010';
                    'GuestRoom4Vac',    'HotelSmall AlwaysOff';
                    'Laundry',          'HotelSmall BLDG_LIGHT_LAUNDRY_SCH';
                    'Mechanical',       'HotelSmall BLDG_LIGHT_MECHROOM_SCH';
                    'Meeting',          'HotelSmall BLDG_LIGHT_MEETINGROOM_SCH';
                    'Office',           'HotelSmall BLDG_LIGHT_OFFICE_SCH';
                    'PublicRestroom',   'HotelSmall BLDG_LIGHT_RESTROOM_SCH';
                    'StaffLounge',      'HotelSmall BLDG_LIGHT_EMPLOYEELOUNGE_SCH';
                    'Stair',            'HotelSmall BLDG_LIGHT_STAIR_SCH';
                    'Stair4',           'HotelSmall BLDG_LIGHT_STAIR_SCH';
                    'Storage',          'HotelSmall BLDG_LIGHT_STORAGE_SCH';
                    'Storage4Front',    'HotelSmall BLDG_LIGHT_STORAGE_SCH';
                    'Storage4Rear',     'HotelSmall BLDG_LIGHT_STORAGE_SCH';
                    };
            case 'occupancy'
                sData = {
                    'Corridor',         '';
                    'Corridor4',        '';
                    'Elec/MechRoom',    '';
                    'ElevatorCore',     '';
                    'ElevatorCore4',    '';
                    'Exercise',         'HotelSmall ExerciseCenter_Occ_Sch';
                    'GuestLounge',      'HotelSmall Lobby_Occ_Sch';
                    'GuestRoom123Occ',  'HotelSmall GuestRoom_Occ_Sch';
                    'GuestRoom123Vac',  'HotelSmall AlwaysOff';
                    'GuestRoom4Occ',    'HotelSmall GuestRoom_Occ_Sch';
                    'GuestRoom4Vac',    'HotelSmall AlwaysOff';
                    'Laundry',          'HotelSmall LaundryRoom_Occ_Sch';
                    'Mechanical',       '';
                    'Meeting',          'HotelSmall MeetingRoom_Occ_Sch';
                    'Office',           'HotelSmall Office_Occ_Sch';
                    'PublicRestroom',   'HotelSmall Lobby_Occ_Sch';
                    'StaffLounge',      'HotelSmall EmployeeLounge_Occ_Sch';
                    'Stair',            '';
                    'Stair4',           '';
                    'Storage',          '';
                    'Storage4Front',    '';
                    'Storage4Rear',     '';
                    };
            otherwise
                error(strcat('Parameter %s not recognized for', ...
                    ' building type %s.'), param, bType)
        end
    otherwise
        error('Building type %s not recognized.', bType)
end

end

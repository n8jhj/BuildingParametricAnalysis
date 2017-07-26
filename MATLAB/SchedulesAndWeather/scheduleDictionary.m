function sch = scheduleDictionary(name)
%SCHEDULEDICTIONARY Dictionary for EnergyPlus schedules.
%   sch = scheduleDictionary(name)
%   Returns schedule SCH corresponding with key NAME. NAME is a string, and
%   SCH is a struct containing fields Seasons, Weekday, Sat, Sun.

%% Initialize
sch = struct(...
    'Seasons',[], ...
    'Weekday',[], ...
    'Sat',[], ...
    'Sun',[] ...
    );

%% Populate
switch name
    
    % ||||||||||||||||||||||||||||||||||||||||||||||||||||___PRIMARY SCHOOL
    % ||||||||||||||||||||||||||||||||||||||||||||||||||___SECONDARY SCHOOL
    % ||||||||||||||||||||||||||||||||||||||||||||||||||||||___SMALL OFFICE
    % |||||||||||||||||||||||||||||||||||||||||||||||||||||___MEDIUM OFFICE
    % ||||||||||||||||||||||||||||||||||||||||||||||||||||||___LARGE OFFICE
    % |||||||||||||||||||||||||||||||||||||||||||||||||||||||___SMALL HOTEL
    % ------------------------------------------------------------- cooling
    case 'HotelSmall Adva_OccGuestRoom_ClgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            9, 21.1083;
            16, 23.33;
            24, 21.1083;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall CommonArea_ClgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 23.889;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'SmallHotel UnitHeater ClgSP Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 40;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall VacGuestRoom_ClgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 23.33;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    % ----------------------------------------------------------- equipment
    case 'HotelSmall BLDG_ELEVATORS'
        sch.Seasons = 8760;
        sch.Weekday = [
            4, 0.05;
            5, 0.1;
            6, 0.2;
            7, 0.4;
            9, 0.5;
            10, 0.35;
            16, 0.15;
            17, 0.35;
            19, 0.5;
            21, 0.4;
            22, 0.3;
            23, 0.2;
            24, 0.1;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall EmployeeLounge_Eqp_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0.11;
            7, 0.19;
            8, 0.25;
            10, 1;
            12, 0.86;
            13, 1;
            18, 0.86;
            19, 0.25;
            20, 0.19;
            24, 0.11;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall ExerciseCenter_Eqp_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            6, 0;
            7, 0.5;
            9, 1;
            12, 0.5;
            13, 0;
            16, 0.5;
            17, 1;
            19, 0.5;
            21, 1;
            23, 0.5;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall GuestRoom_Eqp_Sch_Base'
        sch.Seasons = 8760;
        sch.Weekday = [
            6, 0.11;
            7, 0.62;
            8, 0.9;
            10, 0.43;
            17, 0.26;
            19, 0.51;
            20, 0.49;
            21, 0.66;
            22, 0.7;
            23, 0.35;
            24, 0.11;
            ];
        sch.Sat = [
            6, 0.11;
            7, 0.3;
            8, 0.62;
            9, 0.9;
            10, 0.62;
            17, 0.29;
            18, 0.43;
            19, 0.51;
            20, 0.49;
            21, 0.66;
            22, 0.7;
            23, 0.35;
            24, 0.11;
            ];
        sch.Sun = sch.Sat;
    case 'HotelSmall LaundryRoom_Eqp_Elec_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            8, 0;
            16, 1;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall Lobby_Eqp_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0.21;
            6, 0.68;
            10, 1;
            11, 0.32;
            23, 0.23;
            24, 0.21;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall MeetingRoom_Eqp_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            7, 0;
            8, 0.05;
            10, 0.54;
            12, 0.26;
            13, 0.05;
            15, 0.54;
            18, 0.26;
            20, 0.05;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall OFF_EQUIP_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0.33;
            7, 0.38;
            10, 0.43;
            12, 1;
            13, 0.94;
            17, 1;
            18, 0.75;
            20, 0.63;
            22, 0.48;
            24, 0.33;
            ];
        sch.Sat = [
            5, 0.33;
            7, 0.38;
            8, 0.43;
            18, 0.63;
            22, 0.48;
            24, 0.33;
            ];
        sch.Sun = sch.Sat;
    % ------------------------------------------------------------- heating
    case 'HotelSmall Adva_OccGuestRoom_HtgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            9, 21.11;
            16, 18.8881;
            24, 21.11;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall CommonArea_HtgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 21.11;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall SemiHeated_HtgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 7.2;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall VacGuestRoom_HtgSP_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 18.889;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    % ------------------------------------------------------------ lighting
    case 'HotelSmall BLDG_LIGHT_CORRIDOR_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 1;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_EMPLOYEELOUNGE_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0;
            6, 0.2;
            7, 0.3;
            8, 0.5;
            18, 1;
            19, 0.5;
            20, 0.3;
            21, 0.2;
            22, 0.05;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_EXERCENTER_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            6, 0;
            7, 0.5;
            22, 1;
            23, 0.5;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_FRONTLOUNGE_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0;
            6, 0.2;
            7, 0.3;
            8, 0.5;
            18, 1;
            19, 0.5;
            20, 0.3;
            21, 0.2;
            22, 0.05;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_GUESTROOM_SCH_2010'
        sch.Seasons = 8760;
        sch.Weekday = [
            1, 0.1859;
            2, 0.1452;
            5, 0.0945;
            6, 0.1859;
            7, 0.4121;
            8, 0.5259;
            10, 0.4121;
            16, 0.2087;
            17, 0.21304;
            18, 0.2149;
            19, 0.6297;
            20, 0.8342;
            21, 0.938;
            22, 0.8342;
            23, 0.6297;
            24, 0.3083;
            ];
        sch.Sat = [
            2, 0.2197;
            6, 0.0945;
            8, 0.3852;
            9, 0.5259;
            10, 0.444267;
            11, 0.302158;
            17, 0.2432;
            18, 0.253275;
            19, 0.7973;
            22, 0.939;
            23, 0.7973;
            24, 0.3852;
            ];
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_LAUNDRY_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            8, 0;
            17, 1;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_MECHROOM_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            7, 0.1;
            8, 0.2;
            18, 0.4;
            22, 0.2;
            24, 0.1;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_MEETINGROOM_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0;
            6, 0.2;
            7, 0.3;
            8, 0.5;
            18, 1;
            19, 0.5;
            20, 0.3;
            21, 0.2;
            22, 0.05;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_OFFICE_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            7, 0.4175;
            8, 0.50935;
            12, 0.7515;
            13, 0.668;
            17, 0.7515;
            18, 0.50935;
            24, 0.4175;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_RESTROOM_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 0.66;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_STAIR_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 0.55;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall BLDG_LIGHT_STORAGE_SCH'
        sch.Seasons = 8760;
        sch.Weekday = [
            7, 0.05418;
            8, 0.10836;
            18, 0.21672;
            22, 0.10836;
            24, 0.05418;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    % ----------------------------------------------------------- occupancy
    case 'HotelSmall EmployeeLounge_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0;
            7, 0.1;
            12, 0.2;
            13, 0.7;
            18, 0.2;
            20, 0.1;
            24, 0;
            ];
        sch.Sat = [
            5, 0;
            8, 0.05;
            12, 0.1;
            13, 0.2;
            18, 0.1;
            20, 0.05;
            24, 0;
            ];
        sch.Sun = sch.Sat;
    case 'HotelSmall ExerciseCenter_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            6, 0;
            7, 0.5;
            11, 1;
            12, 0.5;
            13, 0;
            22, 1;
            23, 0.5;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall GuestRoom_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            6, 1;
            7, 0.77;
            9, 0.43;
            15, 0.2;
            16, 0.31;
            19, 0.54;
            21, 0.77;
            22, 0.89;
            24, 1;
            ];
        sch.Sat = [
            6, 1;
            7, 0.77;
            9, 0.53;
            17, 0.3;
            18, 0.53;
            19, 0.54;
            21, 0.65;
            24, 0.77;
            ];
        sch.Sun = sch.Sat;
    case 'HotelSmall LaundryRoom_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            8, 0;
            10, 0.09;
            12, 0.18;
            13, 0;
            16, 0.18;
            17, 0.09;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall Lobby_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            5, 0.1;
            6, 0.3;
            10, 0.7;
            16, 0.2;
            18, 0.4;
            22, 0.2;
            24, 0.1;
            ];
        sch.Sat = [
            6, 0.1;
            7, 0.3;
            10, 0.7;
            22, 0.2;
            24, 0.1;
            ];
        sch.Sun = sch.Sat;
    case 'HotelSmall MeetingRoom_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            7, 0;
            8, 0.05;
            10, 0.5;
            12, 0.2;
            13, 0.05;
            15, 0.5;
            18, 0.2;
            20, 0.05;
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Sat;
    case 'HotelSmall Office_Occ_Sch'
        sch.Seasons = 8760;
        sch.Weekday = [
            6, 0.2;
            7, 0.3;
            8, 0.4;
            12, 1;
            13, 0.5;
            17, 1;
            18, 0.4;
            19, 0.3;
            24, 0.2;
            ];
        sch.Sat = [
            7, 0.2;
            8, 0.3;
            17, 0.5;
            18, 0.3;
            24, 0.2;
            ];
        sch.Sun = sch.Sat;
    % --------------------------------------------------------------- other
    case 'HotelSmall AlwaysOff'
        sch.Seasons = 8760;
        sch.Weekday = [
            24, 0;
            ];
        sch.Sat = sch.Weekday;
        sch.Sun = sch.Weekday;
        
    % |||||||||||||||||||||||||||||||||||||||||||||||||||||||___LARGE HOTEL
    % |||||||||||||||||||||||||||||||||||||||||||||||||||||||||___WAREHOUSE
    % |||||||||||||||||||||||||||||||||||||||||||||||||___RETAIL STANDALONE
    % ||||||||||||||||||||||||||||||||||||||||||||||||||___RETAIL STRIPMALL
    % ||||||||||||||||||||||||||||||||||||||||||___QUICK SERVICE RESTAURANT
    % |||||||||||||||||||||||||||||||||||||||||||___FULL SERVICE RESTAURANT
    % |||||||||||||||||||||||||||||||||||||||||||||||||___MIDRISE APARTMENT
    % ||||||||||||||||||||||||||||||||||||||||||||||||___HIGHRISE APARTMENT
    % ||||||||||||||||||||||||||||||||||||||||||___QUICK SERVICE RESTAURANT
    % ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||___HOSPITAL
    % ||||||||||||||||||||||||||||||||||||||||||||||||||||||||___OUTPATIENT
    
    otherwise
        error('Input ''name'' not recognized: %s', name)
end

end

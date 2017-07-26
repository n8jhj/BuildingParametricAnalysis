function [pData,units] = spaceParameters(bType,param)
%SPACEPARAMETERS Data about the given parameter for the given building
%type.
%   [pData,units] = spaceParameters(bType,param)
%   Returns a numerical array containing data about parameter PARAM by
%   space type for building type BTYPE, as well as the units of the
%   returned data. UNITS is returned as a string.

switch bType
    case 'Hospital'
        switch param
            case 'equipment'    % W/m^2
                pData = {
                    'Basement',     8.072933;
                    'Corridor',     0.0;
                    'Dining',       10.763910;
                    'ER_Exam',      16.145866;
                    'ER_NurseStn',  14.638918;
                    'ER_Trauma',    43.055642;
                    'ER_Triage',    21.527821;
                    'ICU_NurseStn', 21.527821;
                    'ICU_Open',     32.291731;
                    'ICU_PatRm',    32.291731;
                    'Kitchen',      80.729328;
                    'Lab',          43.055642;
                    'Lobby',        0.753474;
                    'NurseStn',     11.194467;
                    'Office',       10.763910;
                    'OR',           43.055642;
                    'PatRoom',      21.527821;
                    'PhysTherapy',  16.145866;
                    'Radiology',    107.639104;
                    };
                units = 'W/m^2';
            case 'floor_area'   % ft^2
                pData = {
                    'Basement',     40250.03    * 1;
                    'Corridor',     6124.99     * 1 +       ...
                                    6124.99     * 1 +       ...
                                    5400.04     * 1 +       ...
                                    6100.02     * 1 +       ...
                                    6100.02     * 1 +       ...
                                    6100.02     * 1 +       ...
                                    6100.02     * 1;
                    'Dining',       7499.97     * 1;
                    'ER_Exam',      299.99      * 4 +    	...
                                    299.99      * 4;
                    'ER_NurseStn',  13300.0     * 1;
                    'ER_Trauma',    299.99      * 1 +       ...
                                    299.99      * 1;
                    'ER_Triage',    299.99      * 4;
                    'ICU_Open',     6651.67     * 1;
                    'ICU_NurseStn', 7198.58     * 1;
                    'ICU_PatRm',    224.97      * 5 +       ...
                                    299.99      * 1 +       ...
                                    224.97      * 6;
                    'Kitchen',      10000.0     * 1;
                    'Lab',          2849.96     * 1 +       ...
                                    2849.96     * 1;
                    'Lobby',        15874.72    * 1;
                    'NurseStn',     9749.95     * 1 +       ...
                                    9749.95     * 1 +       ...
                                    11199.96    * 1;
                    'Office',       750.24      * 1 +       ...
                                    150.05      * 5 +       ...
                                    750.03      * 5 +       ...
                                    750.03      * 1 +       ...
                                    150.05      * 6;
                    'OR',           599.98      * 1 +       ...
                                    599.98      * 5 +       ...
                                    599.98      * 1 +       ...
                                    2400.03     * 1 +       ...
                                    10899.97    * 1;
                    'PatRoom',      224.97      * 10 +      ...
                                    224.97      * 10 +      ...
                                    375.01      * 1 +       ...
                                    375.01      * 1 +       ...
                                    217.54      * 10 +      ...
                                    217.54      * 10 +      ...
                                    375.01      * 1 +       ...
                                    375.01      * 1 +       ...
                                    224.97      * 10 +      ...
                                    224.97      * 10 +      ...
                                    299.99      * 1 +       ...
                                    299.99      * 1 +       ...
                                    217.54      * 10 +      ...
                                    217.54      * 10 +      ...
                                    299.99      * 1 +       ...
                                    299.99      * 1;
                    'PhysTherapy',  5249.99     * 1;
                    'Radiology',    5249.99     * 1;
                    };
                units = 'ft^2';
            case 'lighting'     % W/m^2
                pData = {
                    'Basement',     9.579880;
                    'Corridor',     9.579880;	
                    'Dining',       6.996542;
                    'ER_Exam',      24.326438;
                    'ER_NurseStn',  9.364602;
                    'ER_Trauma',    24.326438;
                    'ER_Triage',    24.326438;
                    'ICU_NurseStn', 9.364602;
                    'ICU_Open',     12.378497;
                    'ICU_PatRm',    6.673624;
                    'Kitchen',      10.656271;
                    'Lab',          19.482678;
                    'Lobby',        9.687519;
                    'NurseStn',     9.364602;
                    'Office',       10.763910;
                    'OR',           20.343791;
                    'PatRoom',      6.673624;
                    'PhysTherapy',  9.795158;
                    'Radiology',    14.208362;
                    };
                units = 'W/m^2';
            case 'occupancy'    % ppl/m^2
                pData = {
                    'Basement',     0.026910;	
                    'Corridor',     0.010764;	
                    'Dining',       0.107639;
                    'ER_Exam',      0.215278;
                    'ER_NurseStn',  0.014316;
                    'ER_Trauma',    0.215278;
                    'ER_Triage',    0.215278;
                    'ICU_NurseStn', 0.014316;
                    'ICU_Open',     0.053820;
                    'ICU_PatRm',    0.053820;
                    'Kitchen',      0.053820;
                    'Lab',          0.053820;
                    'Lobby',        0.014316;
                    'NurseStn',     0.014316;
                    'Office',       0.075347;
                    'OR',           0.053820;
                    'PatRoom',      0.053820;
                    'PhysTherapy',  0.053820;
                    'Radiology',    0.053820;
                    };
                units = 'ppl/m^2';
            otherwise
                error(strcat('Parameter %s not recognized for', ...
                    ' building type %s.'), param, bType)
        end
    case 'PrimarySchool'
        switch param
            case 'equipment' % W/m^2
                pData = {
                    'Cafeteria',    25.402829;
                    'Classroom',    14.961835;
                    'Corridor',     3.982647;
                    'Gym',          4.951399;
                    'Kitchen',      190.521214;
                    'Lobby',        3.982647;
                    'Mechanical',   3.982647;
                    'Office',       10.763910;
                    'Restroom',     3.982647;
                    };
                units = 'W/m^2';
            case 'floor_area' % ft^2
                pData = {
                    'Cafeteria',    3390.63     * 1;
                    'Classroom',    1743.75     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    4294.8      * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    3390.63     * 1;
                    'Corridor',     2066.67     * 1 +   ...
                                    2066.67     * 1 +   ...
                                    2066.67     * 1 +   ...
                                    5877.1      * 1;
                    'Gym',          3842.72     * 1;
                    'Kitchen',      1808.34     * 1;
                    'Lobby',        1840.63     * 1;
                    'Mechanical'    2712.51     * 1;
                    'Office'        4746.88     * 1;
                    'Restroom'      2045.14     * 1;
                    };
                units = 'ft^2';
            case 'lighting' % W/m^2
                pData = {
                    'Cafeteria',    6.996542;
                    'Classroom',    13.347249;
                    'Corridor',     7.104181;
                    'Gym',          7.750016;
                    'Kitchen',      10.656271;
                    'Lobby',        9.687519;
                    'Mechanical',   10.225715;
                    'Office',       11.947941;
                    'Restroom',     10.548632;
                    };
                units = 'W/m^2';
            case 'occupancy' % ppl/m^2
                pData = {
                    'Cafeteria',    1.076391;
                    'Classroom',    0.269098;
                    'Corridor',     0.0;
                    'Gym',          0.322917;
                    'Kitchen',      0.149941;
                    'Lobby',        0.0;
                    'Mechanical',   0.0;
                    'Office',       0.053820;
                    'Restroom',     0.0;
                    };
                units = 'ppl/m^2';
            otherwise
                error(strcat('Parameter %s not recognized for', ...
                    ' building type %s.'), param, bType)
        end
    case 'SecondarySchool'
        switch param
            case 'equipment' % W/m^2
                pData = {
                    'Auditorium',   4.951399;
                    'Cafeteria',    76.961959;
                    'Classroom',    9.999673;
                    'Corridor',     3.982647;
                    'Gym',          4.951399;
                    'Kitchen',      222.274750;
                    'Library',      10.010437;
                    'Lobby',        3.982647;
                    'Mechanical',   3.982647;
                    'Office',       10.763910;
                    'Restroom',     3.982647;
                    };
                units = 'W/m^2';
            case 'floor_area' % ft^2
                pData = {
                    'Auditorium',   10634.74    * 1;
                    'Cafeteria',    6716.68     * 1;
                    'Classroom',    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    1065.63     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1 +   ...
                                    5134.39     * 1;
                    'Corridor',     3444.45     * 1 +   ...
                                    3444.45     * 1 +   ...
                                    3444.45     * 1 +   ...
                                    3444.45     * 1 +   ...
                                    3444.45     * 1 +   ...
                                    3444.45     * 1 +   ...
                                    12270.86    * 1 +   ...
                                    12270.86    * 1;
                    'Gym',          13433.36    * 1 +   ...
                                    21269.49    * 1;
                    'Kitchen',      2325.0      * 1;
                    'Library',      9041.68     * 1;
                    'Lobby',        2260.42     * 1 +   ...
                                    2260.42     * 1;
                    'Mechanical',   3681.26     * 1 +   ...
                                    3681.26     * 1;
                    'Office',       5726.4      * 1 +   ...
                                    5726.4      * 1;
                    'Restroom',     2260.42     * 1 +   ...
                                    2260.42     * 1;
                    };
                units = 'ft^2';
            case 'lighting' % W/m^2
                pData = {
                    'Auditorium',   8.503489;
                    'Cafeteria',    6.996542;
                    'Classroom',    13.347249;
                    'Corridor',     7.104181;
                    'Gym',          7.750016;
                    'Kitchen',      10.656271;
                    'Library',      12.701414;
                    'Lobby',        9.687519;
                    'Mechanical',   10.225715;
                    'Office',       11.947941;
                    'Restroom',     10.548632;
                    };
                units = 'W/m^2';
            case 'occupancy' % ppl/m^2
                pData = {
                    'Auditorium',   1.614587;
                    'Cafeteria',    1.076391;
                    'Classroom',    0.376737;
                    'Corridor',     0.0;
                    'Gym',          0.322917;
                    'Kitchen',      0.163934;
                    'Library',      0.107639;
                    'Lobby',        0.0;
                    'Mechanical',   0.0;
                    'Office',       0.053820;
                    'Restroom',     0.0;
                    };
                units = 'ppl/m^2';
            otherwise
                error(strcat('Parameter %s not recognized for', ...
                    ' building type %s.'), param, bType)
        end
    case 'SmallHotel'
        switch param
            case 'equipment' % W/m^2
                pData = {
                    'Corridor',         0.0;
                    'Corridor4',        0.0;
                    'Elec/MechRoom',    2133.407045;
                    'ElevatorCore',     0.0;
                    'ElevatorCore4',    0.0;
                    'Exercise',         18.621565;
                    'GuestLounge',      26.048663;
                    'GuestRoom123Occ',  11.840301;
                    'GuestRoom123Vac',  11.840301;
                    'GuestRoom4Occ',    11.840301;
                    'GuestRoom4Vac',    11.840301;
                    'Laundry',          27.663250;
                    'Mechanical',       0.0;
                    'Meeting',          6.178485;
                    'Office',           13.777805;
                    'PublicRestroom',   0.0;
                    'StaffLounge',      21.527821;
                    'Stair',            0.0;
                    'Stair4',           0.0;
                    'Storage',          0.0;
                    'Storage4Front',    0.0;
                    'Storage4Rear',     0.0;
                    };
                units = 'W/m^2';
            case 'floor_area' % ft^2
                pData = {
                    'Corridor',         1620.08     * 1 +   ...
                                        1350.01     * 1 +   ...
                                        1350.01     * 1;
                    'Corridor4',        1350.01     * 1;
                    'Elec/MechRoom',    162.0       * 1;
                    'ElevatorCore',     162.0       * 1 +   ...
                                        162.0       * 1;
                    'ElevatorCore4',    162.0       * 1;
                    'Exercise',         351.01      * 1;
                    'GuestLounge',      1755.16     * 1;
                    'GuestRoom123Occ',  351.01      * 1 +   ... % 103
                                        351.01      * 1 +   ... % 104
                                        351.01      * 1 +   ... % 105
                                        1404.15     * 1 +   ... % 202_205
                                        1134.09     * 1 +   ... % 206_208
                                        1404.15     * 1 +   ... % 209_212
                                        351.01      * 1 +   ... % 213
                                        351.01      * 1 +   ... % 214
                                        351.01      * 1 +   ... % 219
                                        1404.04     * 1 +   ... % 220_223
                                        351.01      * 1 +   ... % 224
                                        1404.15     * 1 +   ... % 309_312
                                        351.01      * 1 +   ... % 314
                                        1404.04     * 1 +   ... % 315_318
                                        1404.04     * 1;        % 320_323
                    'GuestRoom123Vac',  351.01      * 1 +   ... % 101
                                        351.01      * 1 +   ... % 102
                                        351.01      * 1 +   ... % 201
                                        1404.04     * 1 +   ... % 215_218
                                        351.01      * 1 +   ... % 301
                                        1404.15     * 1 +   ... % 302_305
                                        1134.09     * 1 +   ... % 306_308
                                        351.01      * 1 +   ... % 313
                                        351.01      * 1 +   ... % 319
                                        351.01      * 1;        % 324
                    'GuestRoom4Occ',    351.01      * 1 +   ... % 401
                                        1404.15     * 1 +   ... % 409_412
                                        1404.04     * 1 +   ... % 415_418
                                        351.01      * 1 +   ... % 419
                                        1404.04     * 1 +   ... % 420_423
                                        351.01      * 1;        % 424
                    'GuestRoom4Vac',    1404.15     * 1 +   ... % 402_405
                                        1134.09     * 1 +   ... % 406_408
                                        351.01      * 1 +   ... % 413
                                        351.01      * 1;        % 414
                    'Laundry',          1053.03     * 1;
                    'Mechanical',       351.01      * 1;
                    'Meeting',          864.02      * 1;
                    'Office',           1404.04     * 1;
                    'PublicRestroom',   351.01      * 1;
                    'StaffLounge',      351.01      * 1;
                    'Stair',            216.03      * 1 +   ...
                                        216.03      * 1 +   ...
                                        216.03      * 1 +   ...
                                        216.03      * 1 +   ...
                                        216.03      * 1 +   ...
                                        216.03      * 1;
                    'Stair4',           216.03      * 1 +   ...
                                        216.03      * 1;
                    'Storage',          134.98      * 1 +   ...
                                        134.98      * 1 +   ...
                                        134.98      * 1 +   ...
                                        216.03      * 1 +   ...
                                        216.03      * 1 +   ...
                                        216.03      * 1;
                    'Storage4Front',    134.98      * 1;
                    'Storage4Rear',     216.03      * 1;
                    };
                units = 'ft^2';
            case 'lighting' % W/m^2
                pData = {
                    'Corridor',         7.104181;
                    'Corridor4',        7.104181;
                    'Elec/MechRoom',    0.0;
                    'ElevatorCore',     0.0;
                    'ElevatorCore4',    0.0;
                    'Exercise',         7.750016;
                    'GuestLounge',      7.857655;
                    'GuestRoom123Occ',  8.072933;
                    'GuestRoom123Vac',  8.072933;
                    'GuestRoom4Occ',    8.072933;
                    'GuestRoom4Vac',    8.072933;
                    'Laundry',          6.458346;
                    'Mechanical',       10.225715;
                    'Meeting',          13.239610;
                    'Office',           11.947941;
                    'PublicRestroom',   10.548632;
                    'StaffLounge',      7.857655;
                    'Stair',            7.427098;
                    'Stair4',           7.427098;
                    'Storage',          6.781264;
                    'Storage4Front',    6.781264;
                    'Storage4Rear',     6.781264;
                    };
                units = 'W/m^2';
            case 'occupancy' % ppl/m^2
                pData = {
                    'Corridor',         0.0;
                    'Corridor4',        0.0;
                    'Elec/MechRoom',    0.0;
                    'ElevatorCore',     0.0;
                    'ElevatorCore4',    0.0;
                    'Exercise',         0.214632;
                    'GuestLounge',      0.322917;
                    'GuestRoom123Occ',  0.045962;
                    'GuestRoom123Vac',  0.045962;
                    'GuestRoom4Occ',    0.045962;
                    'GuestRoom4Vac',    0.045962;
                    'Laundry',          0.107639;
                    'Mechanical',       0.0;
                    'Meeting',          0.538196;
                    'Office',           0.076854;
                    'PublicRestroom',   0.030677;
                    'StaffLounge',      0.551973;
                    'Stair',            0.0;
                    'Stair4',           0.0;
                    'Storage',          0.0;
                    'Storage4Front',    0.0;
                    'Storage4Rear',     0.0;
                    };
                units = 'ppl/m^2';
            otherwise
                error(strcat('Parameter %s not recognized for', ...
                    ' building type %s.'), param, bType)
        end
    otherwise
        error('Building type %s not recognized.', bType)
end

end

function dataStruct = MTR_importToStruct(filename)
%MTR_IMPORTTOSTRUCT Import an EnergyPlus output .mtr datafile to a struct.
%   dataStruct = ESO_importToStruct(filename)
%   Reads data from the file FILENAME to DATASTRUCT using the function
%   MTR_importFile.

%% Create struct from MTR_importFile output.
% get data values
[Timestamp, meters] = MTR_importFile(filename);

% convert E+ buildings demand: J to kWh
[r,~] = size(meters);
kwh = zeros(length(Timestamp),r);
for i = 1:1:r
    kwh(:,i) = meters{i,2};
end
kwh = kwh ./ 3600000;

% return struct
dataStruct = struct(...
    'Name',filename(5:end-4), ...
    'Timestamp',Timestamp ...
    );
for i = 1:1:r
    dataStruct.(meters{i,1}) = kwh(:,i);
end

end

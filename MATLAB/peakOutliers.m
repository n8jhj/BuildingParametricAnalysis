function pkOtlrs = peakOutliers(data,minMaxRng)
%PEAKOUTLIERS Low and high peak outliers.
%   pkOtlrs = peakOutliers(data,minMaxRng)
%   Return 1x2 array of the minimum of DATA minus the minimum of MINMAXRNG,
%   and the maximum of DATA minus the maximum of MINMAXRNG.

pkOtlrs = [
    min(data) - min(minMaxRng), ...
    max(data) - max(minMaxRng), ...
    ];

end

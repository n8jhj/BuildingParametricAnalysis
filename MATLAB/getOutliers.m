function outliers = getOutliers(data, funcName, varargin)
%GETOUTLIERS Outliers of input data found using input function name.
%   outliers = getOutliers(data, funcName, varargin)
%   Uses function FUNCNAME to find outliers, then returns them. Other
%   necessary arguments for the specific outlier function are contained in
%   VARARGIN. OUTLIERS is an nx2 matrix containing index-value pairs.
%
% Example:
%   outliers = getOutliers(data, 'quartiles', 2);
%   Uses function 'quartiles' to find outliers of DATA with starting fence
%   of 2 (outliers between fences 1 and 2 are not considered outliers).

%% Get outputs from input function
switch funcName
    case 'minPercentRange'
        % check inputs
        nInputs = 1;
        assert(length(varargin) == nInputs, sprintf(...
            'Function ''%s'' requires %i inputs', funcName, nInputs))
        % run function
        pBounds = varargin{1};
        outliers = minPercentRange(data, pBounds);
    case 'quartiles'
        % check inputs
        nInputs = 1;
        assert(length(varargin) == nInputs, sprintf(...
            'Function ''%s'' requires %i inputs', funcName, nInputs))
        % run function
        fenceStart = varargin{1};
        [~,~,~,otlrs] = quartiles(data);
        % get outliers from output
        outliers = vertcat(otlrs(fenceStart:end).fenceGrpLo, ...
            otlrs(fenceStart:end).fenceGrpHi);
    otherwise
        error('Function ''%s'' is not an acceptable option', funcName)
end

end
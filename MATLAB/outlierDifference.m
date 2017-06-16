function [dLo, dHi] = outlierDifference(funcName, varargin)
%OUTLIERDIFFERENCE Difference between absolute maximum and minimum and
%outlier-filtered maximum and minimum, respectively.
%   [dLo, dHi] = outlierDifference(funcName, varargin)
%   Uses function FUNCNAME with inputs contained in VARARGIN to evaluate
%   the outlier-filtered maximum and minimum. Then finds outlier
%   differences.
%
% Acceptable input functions are:
%   minPercentRange(data, pBounds)
%       Outliers are outside the minimum percent range
%   quartiles(data)
%       Outliers are outside 1.5 times the interquartile range
%
% Example:
%   [dLo, dHi] = outlierDifference('minPercentRange', data, pBounds);

%% Get outputs from input function
switch funcName
    case 'minPercentRange'
        % check inputs
        nInputs = 2;
        assert(length(varargin) == nInputs, sprintf(...
            'Function ''%s'' requires %i inputs', funcName, nInputs))
        % run function
        data = varargin{1};
        pBounds = varargin{2};
        [~, filtDat] = feval(funcName, data, pBounds);
        filtDatMin = min(filtDat);
        filtDatMax = max(filtDat);
    case 'quartiles'
        % check inputs
        nInputs = 1;
        assert(length(varargin) == nInputs, sprintf(...
            'Function ''%s'' requres %i inputs', funcName, nInputs))
        % run function
        data = varargin{1};
        [q1, ~, q3] = quartiles(data);
        fence = 1.5 * (q3 - q1);
        filtDatMin = q1 - fence;
        filtDatMax = q3 + fence;
    otherwise
        error('Function ''%s'' is not an acceptable option', funcName)
end

%% Calculate outlier differences
dLo = min(data) - filtDatMin;
dHi = max(data) - filtDatMax;

end

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
%
% Example:
%   [dLo, dHi] = outlierDifference('minPercentRange', data, pBounds);

%% Check inputs
switch funcName
    case 'minPercentRange'
        inpReqd = 2;
end
assert(length(varargin) == inpReqd, ...
    sprintf('Function ''%s'' requires %i inputs', funcName, inpReqd))

%% Run input function
varargout = feval(funcName, varargin{1}, varargin{2});


end
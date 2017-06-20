function positionFigures(varargin)
%POSITIONFIGURES Re-orient position of input figures for better visibility.
%   positionFigures(fig1, fig2)
%   Positions fig1 and fig2 so that neither figure overlaps the other.

%% For each figure in varargin, alter its position
for i = 1:1:length(varargin)
    fig = varargin{i};
    figPos = get(fig, 'OuterPosition');
    deltaX = figPos(3)/2;
    deltaY = (figPos(4) + 10) * (i-1);
    figPos(1) = figPos(1) + deltaX + 10;
    figPos(2) = figPos(2) - deltaY;
    set(fig, 'OuterPosition', figPos)
end

end
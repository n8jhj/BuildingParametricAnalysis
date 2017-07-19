function subplotComparison(x,y,oTitle,titles,xlab,ylab)
%SUBPLOTCOMPARISON Plot comparison of EnergyPlus and EAGERS methods on same
%figure
%   subplotComparison(x,y,oTitle,titles,xlab,ylab)
%   Plots input fields all on same figure.
%
% Example:
%   subplotComparison(x, {y1EA,y2EA,y3EA,y4EA; y1EP,[],[],[]}, 'v1 - SmallOffice-4A', {'Electric','Heating','Cooling','Total'; 'Total Facility'}, {xlab1EA,xlab2EA,xlab3EA,xlab4EA; xlab1EP,[],[],[]}, {ylab1EA,ylab2EA,ylab3EA,ylab4EA; ylab1EP,[],[],[]})

%% Get number rows
sz = size(y);
nRows = sz(2);

%% Check whether inputs are single or multiple values
if ischar(xlab)
    temp = xlab;
    xlab = cell(size(y));
    xlab(~cellfun(@isempty,y)) = {temp};
end
if ischar(ylab)
    temp = ylab;
    ylab = cell(size(y));
    ylab(~cellfun(@isempty,y)) = {temp};
end

%% Create subplots
source = {'EAGERS ','EnergyPlus '};
for i = [1,2]
    for j = 1:1:nRows
        if ~isempty(y{i,j})
            % plot
            subplot(nRows, 2, 2*j-mod(i,2))
            plot(x, y{i,j})
            title({oTitle, [source{i},titles{i,j}]})
            xlabel(xlab{i,j})
            ylabel(ylab{i,j})
        end
    end
end

end

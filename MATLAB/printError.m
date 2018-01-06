function printError(ME, shouldRethrow)
%PRINTERROR Print an error like MATLAB, with option to not quit right away.

if nargin < 2
    shouldRethrow = false;
end

try
    errText = strcat(ME.message, '\n\n');
    for i = 1:1:length(ME.stack)
        fullFile = strrep(ME.stack(i).file, '\', '/');
        fileName = ME.stack(i).name;
        lineNum = ME.stack(i).line;
        hyperlink = strcat('href="matlab: opentoline(which(''', fullFile, ...
            '''),', num2str(lineNum), ')"');
        lineText = [' (<a ', hyperlink, '>line ', num2str(lineNum), '</a>)'];
        errText = strcat(errText, ['Error in ', fileName, lineText, '\n\n']);
    end
    fprintf(2, errText)
catch metaME
    fprintf(2, strcat('Tried printing an error and failed miserably.\n', ...
        'Guess that''s what you get when you try to imitate MATLAB...\n\n'))
    if shouldRethrow
        rethrow(metaME)
    end
    return
end

end

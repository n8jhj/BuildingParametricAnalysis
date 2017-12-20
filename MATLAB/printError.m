function printError(ME, shouldRethrow)
%PRINTERROR Print an error like MATLAB!

if nargin < 2
    shouldRethrow = false;
end

try
    errText = strcat(ME.message, '\n\n');
    for i = 1:1:length(ME.stack)
        fullFile = ME.stack(i).file;
        fileParts = strsplit(fullFile, filesep);
        fileName = fileParts{end};
        lineNum = ME.stack(i).line;
        hyperStr = strcat('href="matlab: opentoline(which(fullFile),%i)"');
        hyperlink = sprintf(hyperStr, lineNum);
        lineText = sprintf([' (<a ', hyperlink, '>line %i</a>)'], ...
            lineNum);
        errText = strcat(errText, ...
            ['Error in ', fileName, lineText, '\n\n']);
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

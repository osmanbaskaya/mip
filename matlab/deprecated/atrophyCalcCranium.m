function [destIm, centerP] = atrophyCalcCranium (suffix, path)

if nargin == 1
    path = cd;
elseif nargin > 2
    fprintf('wrong number of arg');
    return
end

oldPath = cd;
cd(path);
fprintf('\n\n%s\n\n','****** NEW: Atrophy Calculation by Using Cranium ******');

%suffix = 'png';
my_str = dir(['*',suffix,'*']);
fprintf('Path is %s\n\n', cd);

for i=1:length(my_str)
    dataName = my_str(i).name;
    fprintf('%i) Data is %s\n', i, dataName );
    [procIm, sulcal] = extractHemispheres(dataName);
    mid = findMidline(procIm, 1); % 0 means detail OFF.
    points = findHemisphericalDist(procIm, mid);
    [destIm, centerP] = addCranium (procIm, sulcal, points, mid);
    destIm = zeroPadding(destIm, centerP);
end
cd(oldPath);
function [destIm, sulcal, hemisDist] = hemisphericalQuantificationW (suffix, path)

% help düzeltimeldi...
% No figures.
%
% NAME:
%     atrophyCalc - provides an atrophy calculation.
%
% SYNOPSIS:
%     atropyCalc('proportion_of_the_file_name', ['path'])
%
% DESCRIPTION:
%    Function supports regular expression on sending file name.
%    Function accepts one (at least one which interest in file name),
%    or two parameters.
%    Default path is result of !pwd.
%
%  CALL EXAMPLES :
%   [destIm, sulcal, hemisDist] = atrophyCalc('png','/home/tyra/data');
%   [destIm, sulcal, hemisDist] = atrophyCalc('haciahmet');
%
%  destIm is the processing image without lines.
%  sulcal is the output of FAST. 
%

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>

%  $Date: 2010/11/20  



%close all
%clc
if nargin == 1
    path = cd;
elseif nargin > 2
    fprintf('wrong number of arg');
    return
end

allRegionalDist = [];

%suffix = 'png';
fprintf('\n\n%s\n\n','******  NEW: atropyCalc ******');
[my_str, oldPath] = getData(suffix, path);
hemisDist = [];
for i=1:length(my_str)
    dataName = my_str(i).name;
    fprintf('%i) Data is %s\n', i, dataName );
    [n_foo, sulcal] = extractHemispheres1(dataName);
    %[n_foo, sulcal] = extractHemispheresDif(dataName);
    figure, imshow(n_foo), title(dataName);
    
    % h = imdistline(gca,[10 100], [100 100]);
    % getDistance(h)

    %Evaluate the Midline
    hold on, %pixval on
    destIm = n_foo;
    midLineVec = findMidlineVec(n_foo);
    [points, hemisphericalDist, regionalDist] = findHemisphericalDistW(n_foo, midLineVec, dataName);
    hemisDist = [hemisDist; [{dataName}, hemisphericalDist]];
    
    allRegionalDist = [allRegionalDist; regionalDist];
    
end

fprintf('All Regional Distances\n');
allRegionalDist
cd(oldPath);


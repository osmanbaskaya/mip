function [destIm, sulcal, hemisDist] = atrophyCalc1W (suffix, path)

% NAME:
%     atrophyCalc1W - provides a weighted atrophy calculation.
%
% SYNOPSIS:
%     atropyCalc1W('proportion_of_the_file_name', ['path'])
%
% DESCRIPTION:
%    Function supports regular expression on sending file name.
%    Function accepts one (at least one which interest in file name),
%    or two parameters.
%    Default path is result of !pwd.
%
%  CALL EXAMPLES :
%   [destIm, sulcal, hemisDist] = atrophyCalc1W('png','/home/tyra/data')
%   [destIm, sulcal, hemisDist] = atrophyCalc1W('haciahmet')
%
%  destIm is the processing image without lines.
%  sulcal is the output of FAST. 
%

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>

%  $Date: 2011/04/20  

%close all
%clc
if nargin == 1
    path = cd;
elseif nargin > 2
    fprintf('wrong number of arg(s). Number of Arg(s) should be 1 or 2.');
    return
end

%suffix = 'png';
fprintf('\n\n%s\n\n','******  NEW: Weighted atropyCalc ******');
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
    [points, hemisphericalDist] = findHemisphericalDist(n_foo, midLineVec);
    hemisDist = [hemisDist; [{dataName}, hemisphericalDist]];
end
cd(oldPath);


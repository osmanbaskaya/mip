function [destIm] = atrophyCalcNoDrawings (suffix, path)

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
%   [destIm, sulcal] = atrophyCalc('png','/home/tyra/data')
%   [destIm, sulcal] = atrophyCalc('haciahmet')
%
%  Out is the processing image without lines.

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

%suffix = 'png';
%fprintf('\n\n%s\n\n','******  NEW: atropyCalc ******');
[my_str, oldPath] = getData(suffix, path);
%hemisDist = [];
for i=1:length(my_str)
    dataName = my_str(i).name;
    %fprintf('%i) Data is %s\n', i, dataName );
    [n_foo, sulcal] = extractHemispheres(dataName);
    %[n_foo, sulcal] = extractHemispheresDif(dataName);
    %figure, imshow(n_foo), title(dataName);
    
    % h = imdistline(gca,[10 100], [100 100]);
    % getDistance(h)

    %Evaluate the Midline
    %hold on, %pixval on
    destIm = n_foo;
    %midLineVec = findMidlineVec(n_foo);
    %[points, hemisphericalDist] = findHemisphericalDist(n_foo, midLineVec);
    %hemisDist = [hemisDist; [{dataName}, hemisphericalDist]];
end
cd(oldPath);


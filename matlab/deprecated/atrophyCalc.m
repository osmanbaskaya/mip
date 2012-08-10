function [destIm, sulcal, hemisDist] = atrophyCalc (suffix, path, ...
                                        min_size, slice_num, option)

% ATROPHYCALC   Provides an atrophy calculation. 
%
% TODO: Bir parametre daha alacak bu fonksiyon. O da silinecek label'in
%   boyutu. 800 gibi 15 gibi. O arguman extract hemisphere fonk. verilecek.
% SYNOPSIS:
%     atropyCalc('proportion_of_the_file_name', ['path'])
%
% DESCRIPTION:
%    Function supports regular expression on inputting file name(s).
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
elseif nargin > 5
    error('Wrong number of args!!\n');
end

%suffix = 'png';
if (strcmp(option, 'verbose'))
    fprintf('\n\n%s\n\n','******  NEW: atropyCalc ******');
end
[my_str, oldPath] = getData(suffix, path);
hemisDist = [];
for i=1:length(my_str)
    dataName = my_str(i).name;
    if (strcmp(option, 'verbose'))
        fprintf('%i) Data is %s\n', i, dataName );
    end
    
    [n_foo, sulcal] = extractHemispheres(dataName, min_size, slice_num, option);
    %[n_foo, sulcal] = extractHemispheresDif(dataName);
    if (strcmp(option, 'verbose'))
        figure, imshow(n_foo), title(dataName);
    end
    % h = imdistline(gca,[10 100], [100 100]);
    % getDistance(h)
    
    %Evaluate the Midline
    if (strcmp(option, 'verbose'))
        hold on, %pixval on
    end
    destIm = n_foo;
    midLineVec = findMidlineVec(n_foo, option);
    [~, hemisphericalDist] = findHemisphericalDist(n_foo, midLineVec, option);
    hemisDist = [hemisDist; [{dataName}, hemisphericalDist]];
end
cd(oldPath);


function [destIm, sulcal, hemisDist] = atrophyCalc1 (suffix, path, option)

% NAME:
%     atrophyCalc - provides an atrophy calculation.
%
% SYNOPSIS:
%     atropyCalc('proportion_of_the_file_name' [,'path'])
%
% DESCRIPTION:
%    Function supports regular expression on sending file name.
%    Function accepts one (at least one which interest in file name),
%    or two parameters.
%    Default path is result of !pwd.
%
%  CALL EXAMPLES :
%   [destIm, sulcal, hemisDist] = atrophyCalc1('png','/home/tyra/data');
%   [destIm, sulcal, hemisDist] = atrophyCalc1('haciahmet');
%
%  destIm is the processing image without lines.
%  sulcal is the output of FAST. 
%

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>

%  $Date: 2010/11/20  

DEPLOYPATH = '/home/tyr/Documents/datasets/mipdatasets/';

%close all
%clc
if nargin == 1
    path = cd;
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
    [n_foo, sulcal] = extractHemispheres(dataName, 800, option);
    %[n_foo, sulcal] = extractHemispheresDif(dataName);
    
    if (strcmp(option, 'verbose'))
        figure, imshow(n_foo); title(dataName);
        if strmatch(path, strcat(DEPLOYPATH, 'brains/miccai12'))
            cd(strcat(DEPLOYPATH, 'raw_brains/', 'miccai12'));
            sulcal1 = imread(dataName);
            figure, imshow(sulcal1);
            hold on       
        end
        title(dataName);
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


function [points, totalHD] = findHemisphericalDist (sourceIm, mid, option)
% FINDHEMISPHERICALDIST Print weighted atrophy quantification and return
%       two points of every blue line and "Total Hemispherical Distance" of
%       this brain.
%
%   SYNOPSIS:
%       findHemisphericalDist(output_of_extractHemispheres_Function, midLineVec)
%
%   DESCRIPTION:
%       This function helps to draw lines and calculates length of every
%       lines.
%
%   CALL EXAMPLES :
%       findHemisphericalDist(extractHemispheres('baharpelin.img'), findMidlineVec(n_foo))
%
%   Author(s): Osman Baskaya <osman.baskaya@computer.org>
%   Date: 2010/11/20


[h, w] = size(sourceIm);
jump = floor(h / 256);  % frequency of drawing lines.
% our treshold is midlineIndex.
totalDist = 0;
my_counter = 0;
points = []; % points lists,


for j=jump:jump:h
    %alttaki assignment, row'u alır ve 1 olanların indexini bulur
    currRow = find(bwdist(sourceIm(j,:) ~= 0) == 0); % 0 geleni yakalamak.
    midLineIndex = mid(find(mid(:,1) == j, 1), 2);
    if isempty(midLineIndex)
        continue;
    end
    arr1 = currRow(currRow > midLineIndex);
    arr2 = currRow(currRow < midLineIndex);
    if isempty(arr1) || isempty(arr2)
        continue; % midline'in önünde arkasında kalanlardan biri bile boş kümeyse doğru çizilemez.
    end
    maxAxis = arr1(1); % the min of Max points
    minAxis= arr2(end); % the max of Min points
    thisDist = dist(maxAxis,minAxis);
    
    if(thisDist <= 3) % It can be 'PseudoDistance'. Threshold is 3.
        continue;
    else
        totalDist = totalDist + thisDist;
    end
    
    if (strcmp(option, 'verbose'))
        points = [points, {[minAxis, maxAxis, j]}]; %points{1} -> (minAxis,j),(maxAxis,j)
        plot([minAxis, maxAxis],[j,j],'-');
    end
    my_counter = my_counter + 1;
end
if (strcmp(option, 'verbose'))
    fprintf('\t\t- Total distance is %i\n', totalDist);
    fprintf('\t\t- Number of line is %i\n', my_counter);
end
totalHD  = totalDist / my_counter;
if (strcmp(option, 'verbose'))
    fprintf('\t\t- Average-distance is %f\n', totalHD);
end

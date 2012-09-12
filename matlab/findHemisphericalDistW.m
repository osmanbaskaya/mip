function [points, totalHD, regionalDist] = findHemisphericalDistW (sourceIm, mid, dataName)

% NAME:
%    findHemisphericalDist - print weighted atrophy quantification and return
%    two points of every blue line and "Total Hemispherical Distance" of
%    this brain.
%
% SYNOPSIS:
%     findHemisphericalDist(output_of_extractHemispheres_Function, midLineVec)
%
% DESCRIPTION:
%    This function helps to draw lines and calculates length of every
%    lines.
%
%  CALL EXAMPLES :
%   findHemisphericalDist(extractHemispheres('dataName'), findMidlineVec(n_foo))
%

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>
%  $Date: 2010/11/20  


    [h, w] = size(sourceIm);
    jump = h / 256;  % frequency of drawing lines.    
    % our treshold is midlineIndex.
    totalDist = 0;
    my_counter = 0;
    points = []; % points lists,
    reg1_d = 0;
    reg2_d = 0;
    reg3_d = 0;
    
    
    numberOfRegion = 3;
    
    
    %path = '/home/tyra/data/skulls1';
    %skullRadius = calculateSkullRadius1(dataName, path);
    %fprintf('Skull Radius of %s is %d\n', dataName, skullRadius);
    %figure, imshow(sourceIm), hold on;

    borders = skullBorder(sourceIm, jump, mid);
    regionDist = (borders(2) - borders(1)) / numberOfRegion;
    fprintf('regionDist %d, borders 1 %d, borders2 %d\n', regionDist, borders(1), borders(2));
    for j=jump:jump:h
        %alttaki assignment, row'u alır ve 1 olanların indexini bulur
        currRow = find(bwdist(sourceIm(j,:) ~= 0) == 0); % 0 geleni yakalamak.
        midLineIndex = mid(find(mid(:,1) == j, 1), 2);
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
         end
         
        if (j < borders(1) + regionDist)
            color = 'y';
            reg1_d = reg1_d + thisDist;
       
        elseif (j >= borders(1) + regionDist && j< borders(2)- regionDist)
            color = 'r';
            reg2_d = reg2_d + thisDist;
        else
            color = 'b';
            reg3_d = reg3_d + thisDist;
        end
            
        totalDist = totalDist + thisDist;
        
        points = [points, {[minAxis, maxAxis, j]}]; %points{1} -> (minAxis,j),(maxAxis,j)
        plot([minAxis, maxAxis],[j,j], color);
        my_counter = my_counter + 1;
    end
    
    
    regionalDist = [reg1_d, reg2_d, reg3_d];
    
    fprintf('r1 %i, r2 %i, r3 %i\n', reg1_d, reg2_d, reg3_d);
    fprintf('total distance is %i\n', totalDist);
    fprintf('number of line is %i\n', my_counter);
    totalHD  = totalDist / my_counter;
    fprintf('average-distance is %f\n\n', totalHD);
    
    
end
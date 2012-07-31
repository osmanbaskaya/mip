function [destIm, centerPoint] = addCranium (procIm, fastOut, points, mid)

% fastOut is processed image by using FAST
% procIm is the output of the function atrophCalc

if nargin < 3
    fprintf('wrong number of arg');
    return
end

sulcalPerim = bwperim(fastOut);
destIm = or(sulcalPerim, procIm);
figure, imshow(destIm);


% plotting center point...
if nargin == 4
    y = (points{1}(3) + points{end}(3)) / 2;
    x = mid;
    hold on, plot(x, y, 'ro');
    centerPoint = [x, y]; % centerPoint(x,y) = image(y,x)
end




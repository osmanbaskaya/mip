function midLine = findMidline (sourceIm, detail)
% FINDMIDLINE Find the midline vector of source image.
%   If the detail argument is 1, then this function shows
%   some details of midline.
%
%   Author: Osman Baskaya <osman.baskaya@computer.org>
%   Date: 2010


[h, w] = size(sourceIm);

%Evaluate the Midline
hold on, %pixval on
deg = floor(w/2);
line = sourceIm(:,deg);
midLineIndex = deg;
for k=deg:deg+10
    total = sum(line);
    if total == 0
        midLineIndex = k; % Perfect Line. break immediately.
        break;
    end
    lineNext = sourceIm(:,k+1);
    if sum(line) > sum(lineNext)
        line = lineNext;
        midLineIndex = k;
    end
end

if sum(line) ~= 0
    line2 = sourceIm(:,deg);
    midLineIndex2 = deg;
    for l=deg:-1:deg-10
        total = sum(line2);
        if total == 0
            midLineIndex2 = l; % Perfect Line. break immediately.
            break;
        end
        lineNext = sourceIm(:,l+1);
        if sum(line2) > sum(lineNext)
            line2 = lineNext;
            midLineIndex2 = l;
        end
    end
    if sum(line2) < sum(line)
        midLineIndex = midLineIndex2;
        line = line2;
    end
end

%plotting for detailed version.
if detail == 1
    disp(['midLineIndex is ', num2str(midLineIndex)]);
    disp(['number of overlap is ', num2str(sum(line))]);
    plot([midLineIndex,midLineIndex], [0,h-1], 'r');
end

midLine = midLineIndex;

function [fullCurveLeft, fullCurveRight, C] = iteratedCurvePathFinder ...
    (I, seedPoints)
% ITERATEDCURVEPATHFINDER This function measures the left and
%   right central sulcus in iterative manner. That is, firstly Laplace's
%   equation are solved and then normal vectors of laplace results
%   are used to determine the direction which we should follow.
%   Whenever we get stucked somewhere, whole process starts with
%   the original image again but our starting point is the pixel where
%   we got stuck. This process lasts until reaching the convex hull of
%   skull.
%
%   We follow this approach because narrow regions of input image, especially
%   beginning of sulci, immediately goes to 1 which provides us NaN when
%   we calculate gradients of these pixels.
%
%
%   Author: Osman Baskaya <osman.baskaya@computer.org>
%   Date: 22/05/2012

color = '--g';

leftNotFinished = 1;
rightNotFinished = 1;

jump = 5;
EPS = 0.001;


C = zeros(size(I));

intensities = unique(I);
csf_intens = intensities(2);
J = I > csf_intens; % removing all csf regions. Other regions are 1 now.
Conv = bwconvhull(J); %Convex Hull of I
Conv = bwperim(Conv, 8);

fullCurveLeft = [];
fullCurveRight = [];

while(1)
    
    prevLapI = rand(size(I));
    LapI = [];
    prevChange = Inf;
    % Everything set to 0 here for next while loop.
    longestCurveLeft = [];
    longestCurveRight = [];
    longestPathLengthLeft = 0;
    longestPathLengthRight = 0;
    i = 0;
    while(1)
        
        i = i + 1;
        LapI = EcalculateLaplaceBrain(I, LapI, jump);

        
        change = sum(sum(abs(LapI - prevLapI)));
        
        if (prevChange - change < 0)
            fprintf('###Warning: This is not monotonic decreased.####\n');
        end
        
        if (change < EPS)
            fprintf('The change %f < EPS %d\n', change, EPS);
            fprintf('Finished. The Last Iteration no: %d\n', i);
            fprintf('The last Laplace is %d\n', jump * i);
            break;
        end
        [Nx, Ny] = getNormalVectorsOfLaplacian(LapI);
        
        if leftNotFinished
            [depthLeft, curvePathLeft] = getSulcalDepth(seedPoints(1:2), ...
                Nx, Ny, J, color);
            if (depthLeft > longestPathLengthLeft)
                longestCurveLeft = curvePathLeft;
                longestPathLengthLeft = depthLeft;
            end
        end
        
        if rightNotFinished
            [depthRight, curvePathRight] = getSulcalDepth(seedPoints(3:4), ...
                Nx, Ny, J, color);
            if (depthRight > longestPathLengthRight)
                longestCurveRight = curvePathRight;
                longestPathLengthRight = depthRight;
            end
        end
        
        if (~isempty(curvePathLeft))
            idx = sub2ind(size(C), curvePathLeft(:,2), curvePathLeft(:,1));
            C(idx) = C(idx) + 1; % path ciziliyor burada iki taraftan da.
            if ~isempty(find(Conv(idx) > 0, 1))
                leftNotFinished = 0;
                curvePathLeft = [];
                fprintf('Left side Finished\n');
                fprintf('Left = # of LapI: %d\n', jump*i);
            end
        end
        
        if (~isempty(curvePathRight))
            idx = sub2ind(size(C), curvePathRight(:,2), curvePathRight(:,1));
            C(idx) = C(idx) + 1;
            if ~isempty(find(Conv(idx) > 0, 1))
                rightNotFinished = 0;
                curvePathRight = [];
                fprintf('Right side Finished\n');
                fprintf('Right = # of LapI: %d\n', jump*i);
            end
        end
        
        if (~leftNotFinished && ~rightNotFinished)
            break;
        end
        
        if (mod(jump*i, 500) == 0)
            fprintf('Sum of all elements of LapI: %f\n', sum(sum(LapI)));
            fprintf('# of LapI: %d\n', jump*i);
        end
        
        prevLapI = LapI;
        prevChange = change;
        
    end
    
    if (~isempty(longestCurveLeft) && ~isempty(fullCurveLeft))
        
        numerator = length(unique(fullCurveLeft, 'rows'));
        denominator = length(fullCurveLeft);
        if (leftNotFinished && all(fullCurveLeft(end, :) == longestCurveLeft(end, :)))
            fprintf('Problem: Left Already Visited!\n')
            longestCurveLeft = jumpNow('left', J, seedPoints(1:2));
            fprintf('NewLeftSeed = (%d, %d)\n', longestCurveLeft(1:2));
            
        elseif (numerator/denominator < 0.5)
            % Stuck here! Hic ilerleyemeden bir yere takildi
            longestCurveLeft = [longestCurveLeft; jumpNow('left', J, ...
                seedPoints(1:2))];
        end
    end
    
    if (~isempty(longestCurveRight) && ~isempty(fullCurveRight))
        
        numerator = length(unique(fullCurveRight, 'rows'));
        denominator = length(fullCurveRight);
        
        if (rightNotFinished && all(fullCurveRight(end, :) == longestCurveRight(end, :)))
            fprintf('Problem: Right Already Visited!\n')
            longestCurveRight = jumpNow('right', J, seedPoints(1:2));
            fprintf('NewRightSeed = (%d, %d)\n', longestCurveRight(1:2))
        elseif (numerator/denominator < 0.5)
            % Stuck here!
            longestCurveRight = [longestCurveRight; jumpNow('right', J, ...
                seedPoints(3:4))];
        end
    end
    
    fullCurveLeft = [fullCurveLeft; longestCurveLeft];
    fullCurveRight = [fullCurveRight; longestCurveRight];
    
    if (~leftNotFinished && ~rightNotFinished)
        fprintf('Finished. The Last Iteration no: %d\n', i);
        fprintf('The last Laplace is %d\n', jump * i);
        break;
    end
    
    % new seedPoints.
    if (leftNotFinished)
        if isempty(longestCurveLeft)
            fprintf('Left cannot be finished...\n')
            leftNotFinished = 0;
            
        else
            seedPoints(1:2) = longestCurveLeft(end,:);
        end
    end
    
    if(rightNotFinished)
        if isempty(longestCurveLeft)
            fprintf('Right cannot be finished...\n')
            rightNotFinished = 0;
        else
            seedPoints(3:4) = longestCurveRight(end,:);
        end
    end
    
end

end


function newSeeds = jumpNow(direction, I, seedPoints)

x = seedPoints(1);
y = seedPoints(2);

dir = [];

if (strcmp('left', direction))
    for i=-3:1
        for j=-3:1
            if (I(y+i, x+j) == 0)
                dir = [i, j];
                break
            end
        end
    end
else
    for i=3:1
        for j=3:1
            if (I(y+i, x+j) == 0)
                dir = [i, j];
                break
            end
        end
    end
end

newSeeds = [x + dir(2), y + dir(1)];

end
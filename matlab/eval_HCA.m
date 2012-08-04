function corticalDist = eval_HCA (I, skull, dataName, min_size, option)

tic

fprintf('\t-> HCA Evaluation: ');

%% Hemisphere Extraction, Inner Tabula Extraction, Combination of these two

I_extracted = extractHemispheres(I, min_size, option);
outskull = get_cranium(skull);
brainSkull = or(outskull, I_extracted); % combine cranium and extracted brain
brainSkull = imrotate(brainSkull, 90); % nii images should be rotated.


%% Cartesian to Polar 

[w, h] = size(brainSkull);
centralPoint = [w/2, h/2]; % Central point of our brain.


[x, y] = find(brainSkull == 1); % these coordinates should be transform

% Translation in respect to central point
x = x - centralPoint(1); % translation for x axis.
y = y - centralPoint(2); % translation for y axis.

[p_x, p_y] = cart2pol(x,y);


%% Constants

INCR = 0.01; % 5 degree = 0.0436 Radian, default: 0.0236
TOL = 0.0150; % ~ 1.66 degree.

% If image is small increase the tolerance a bit.
if (w < 400)
    TOL = TOL * 2;
end

BOUNDRY = 0.3; % Do not scan these interval. default = 0.3
PSEUDODIST = 3.0; % Pseudo-Distance, default = 6

passHalf = 0; % For lower boundry.

%% Calculation

i = min(p_x) + BOUNDRY - 0.05; % Starting Criteria : the least angle value.
j = max(p_x) - BOUNDRY; % Stopping Criteria : the largest angle value.

numberOfLine = 0;
totalLineLength = 0;

if (strcmp(option, 'verbose'))
    figure, imshow(brainSkull);
    hold on, plot(centralPoint(2), centralPoint(1), 'ro') % Central Point.
end

while i <= j
    
    indices = find(p_x > i & p_x < i + TOL); 
    %indices = find(p_x > i + 6 & p_x < i + TOL + 6);
    angles  = p_x(indices);
    len = p_y(indices);
    interestedP = [angles len];
    interestedP = sortrows(interestedP, 2); % Sort rows by length.
    
    while size(interestedP) > 1
        cons = length(interestedP);
        cranialPoint = interestedP(end,:);
        lastCelPoint = interestedP(end-1,:);
        
        %Is this a Pseudo-Distance?
        currDist = abs(cranialPoint(2) - lastCelPoint(2));
        if currDist > PSEUDODIST
            
            % && ... We can also put a threshold for points which
            % are besides the cranialPoint. But not necessary now.
            drawPoints = [cranialPoint; lastCelPoint];
            [nx,ny] = pol2cart(drawPoints(:,1), drawPoints(:,2));
            ny = ny+centralPoint(2);
            nx = nx+centralPoint(1);
            if (strcmp(option, 'verbose'))
                plot(ny, nx,'g');
            end
            currLineLength = sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2);
            totalLineLength = totalLineLength + currLineLength;
            %PointArr = [PointArr; drawPoints]; % cizilen noktalar arrayi
            numberOfLine = numberOfLine + 1;
            break;
        else %This distance is a "Pseudo-Distance".. We should pass it.
            %interestedP = removerows(interestedP, length(interestedP)- 1);
            interestedP = interestedP(1:end-1, :);
            i = i + TOL/2;
            continue;
        end
        
    end
    
    if (i > -BOUNDRY+0.1) && passHalf == 0
        i = (i + BOUNDRY);
        passHalf = 1;
    end
    
    i = i + INCR;
end
%imwrite(outSkull, dataName, 'png'); "imwrite denemek icin ekledim"
skullRadius = calculateSkullRadius(skull);
corticalDist = (totalLineLength / numberOfLine) / skullRadius;

if (strcmp(option, 'verbose'))
    fprintf('\n***Cranial distance Calculation***\n\n');
    fprintf('Length of the all lines is %i\n', totalLineLength);
    fprintf('Number of line is %i\n', numberOfLine);
    fprintf('Radius of the Cranium is %i\n', skullRadius);
    fprintf('Average-distance is %f\n\n', averageLineDistance);
end
toc
end
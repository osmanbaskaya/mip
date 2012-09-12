function [brainSkull, distResults, WR] = skullAddingOnlyData (suffix, path, isDraw)

% NOT: Polar Koordinat ekseni 1-2 bolge arasinda basliyor ve
%. counter-clockwise yonunde doğru açı tarıyor.
%
%
%

%tic
%% Get the Data
%
close all
%clc
% if nargin == 1
%     path = cd;
% elseif nargin > 2
%     fprintf('wrong number of arg');
%     return
% end

%fprintf('\n\n%s\n\n','******  NEW: Cranium Distances ******');
[my_str, oldPath] = getData(suffix, path);
dataFile = fopen('/home/tyra/data/Res/Process1/WeightedRes.txt', 'a+');


%% Skull Adding
allWeigthedResults = [];
%allWeigthedResults = zeros(10,4);
tic
fprintf(dataFile, '%s\n', datestr(now));



%cranialResults = [];
%hemisResults = [];
distAll = [];
%patientName = [];

expertResults = [5,4,6,6,6,5,6,8,6,5]';

for k=1:length(my_str)
    
    region1Len = 0;
    numberOfLine1 = 0;
    region2Len = 0;
    numberOfLine2 = 0;
    region3Len = 0;
    numberOfLine3 = 0;
    region4Len = 0;
    numberOfLine4 = 0;


    dataName = my_str(k).name;
    %    fprintf('%i) Data is %s\n', k, dataName );
    %    [destIm1, sulcal1, hemisDist] = atrophyCalc1(dataName, '/home/tyra/data/brains');
    path2 = cd;
    outSkull = imread(dataName);
    outSkull = outSkull(:,:,1);
    skullRadius = calculateSkullRadius(outSkull);
    cd('/home/tyra/data/brains');
    destIm = extractHemispheresNoDrawing(dataName);
    brainSkull = or(outSkull,destIm);
    %cd('/home/tyra/data/brainsSkull')


    cd(path2);

    if (isDraw)
        figure, imshow(brainSkull);
    end

    %end

    % Translation & Transformation

    [w, h] = size(brainSkull);
    centralPoint = [w/2, h/2]; % Central point of our brain.
    [x, y] = find(brainSkull == 1);
    x = x - centralPoint(1); % translation for x axis.
    y = y - centralPoint(2); % translation for y axis.
    if (isDraw)
        hold on, plot(centralPoint(2), centralPoint(1), 'ro') % Central Point.
    end
    [p_x, p_y] = cart2pol(x,y);

    % Some Constants:
    INCR = 0.0186; % 5 degree = 0.0436 Radian
    TOL = 0.0150; % ~ 1 degree.
    BOUNDRY = 0.3; % Taramayacak bu degerleri. default = 0.3
    PSEUDODIST = 3.0; %Pseudo-Distance, default = 3
    passHalf = 0; % For lower boundry.

    % Calculation

    i = min(p_x) + BOUNDRY - 0.05; % Starting Criteria : the least angle value.
    j = max(p_x) - BOUNDRY; % Stopping Creteria : the largest angle value.

    PointArr = [];  % For drawing.
  
    while i <= j

        indices = find(p_x > i & p_x < i + TOL); % example.
        %indices = find(p_x > i + 6 & p_x < i + TOL + 6);
        angles  = p_x(indices);
        len = p_y(indices);
        interestedP = [angles len];
        interestedP = sortrows(interestedP, 2); % Sort rows by len(gth).

        while size(interestedP) > 1
            cons = length(interestedP);
            cranialPoint = interestedP(end,:);
            lastCelPoint = interestedP(end-1,:);

            %is it a Pseudo-Distance?
            currDist = abs(cranialPoint(2) - lastCelPoint(2));
            if currDist > PSEUDODIST

                % && ... We can also put a threshold for points which
                % are besides the cranialPoint. But not necessary now.
                drawPoints = [cranialPoint; lastCelPoint];
                [nx,ny] = pol2cart(drawPoints(:,1), drawPoints(:,2));
                ny = ny+centralPoint(2);
                nx = nx+centralPoint(1);

                PointArr = [PointArr; drawPoints];
                currAngle = cranialPoint(1);
                switch 1
                    case (currAngle>=-3.2 && currAngle < -2.25)
                        %disp('1');
                        drawingColor = 'g';
                        region1Len = region1Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine1 = numberOfLine1 + 1;
                    case (currAngle>=-2.25 && currAngle < -1.50)
                        %disp('1');
                        drawingColor = 'm';
                        region2Len = region2Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine2 = numberOfLine2 + 1;
                    case (currAngle>=-1.50 && currAngle < -0.7)
                        %disp('2');
                        drawingColor = 'y';
                        region3Len = region3Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine3 = numberOfLine3 + 1;
                    case (currAngle>=-0.7 && currAngle < 0)
                        %disp('3');
                        drawingColor = 'r';
                        region4Len = region4Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine4 = numberOfLine4 + 1;
                    case (currAngle>=0 && currAngle < 0.7)
                        %disp('4');
                        drawingColor = 'r';
                        region4Len = region4Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine4 = numberOfLine4 + 1;
                    case (currAngle>=0.7 && currAngle < 1.50)
                        %disp('5');
                        drawingColor = 'y';
                        region3Len = region3Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine3 = numberOfLine3 + 1;
                    case (currAngle>=1.5 && currAngle < 2.25)
                        %disp('6');
                        drawingColor = 'm';
                        region2Len = region2Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine2 = numberOfLine2 + 1;
                    case (currAngle>=2.25&& currAngle < 3.2)
                        %disp('6');
                        drawingColor = 'g';
                        region1Len = region1Len + (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2));
                        numberOfLine1 = numberOfLine1 + 1;
                    otherwise
                        dataFile3 = fopen('/home/tyra/data/Res/Process1/ErrorOccured', 'a+');
                        fclose(dataFile3);
                end

%                currLineLength = (sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2)) * weight;
 %               totalLineLength = totalLineLength + currLineLength;
                
                if (isDraw)
                    plot(ny, nx, drawingColor);
                end
                break;
            else %This distance is a "Pseudo-Distance".. We should pass it.
                interestedP = removerows(interestedP, length(interestedP)- 1);
                i = i + TOL;
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

    %averageLineDistance = (totalLineLength / numberOfLine) / skullRadius;
    %averageLineDistance = averageLineDistance;
    numberOfLineArray = [numberOfLine1 numberOfLine2 numberOfLine3 numberOfLine4];
    regionLengthArray = [region1Len region2Len region3Len  region4Len];
    averageLengthArray = [regionLengthArray ./ numberOfLineArray];
    averageLengthArray = averageLengthArray / (4*skullRadius);
    
    

    %     fprintf('\n***Cranial distance Calculation***\n\n');
    %     fprintf('Length of the all lines is %i\n', totalLineLength);
    %     fprintf('Number of line is %i\n', numberOfLine);
    %     fprintf('Radius of the Cranium is %i\n', skullRadius);
    %     fprintf('Average-distance is %f\n\n', averageLineDistance);
    %toc
    %cranialResults = [cranialResults; averageLineDistance];
    %hemisResults = [hemisResults; hemisDist];
    %hemisDist{1,2} = hemisDist{1,2}/skullRadius;
    %distAll(counter,1) = averageLineDistance;
    distAll = [distAll; averageLengthArray];
    %                    path3 = cd;
    %                   cd('/home/tyra/data/brains/goruntuler');
    %                  saveas(gcf, dataName, 'png');
    %                 cd(path3);

end
%cons = [deger, deger, deger, deger]';
%testRes = [testRes; [cons, distAll]];

%distResults = [distAll, expertResults];

%correl = corr(distResults);
%corrInd = correl(2);

%weightedResult = [w1,w2,w3,w4,corrInd];
%fprintf(dataFile, '%f, %f, %f, %f -> %f\n', weightedResult);
%allWeigthedResults = [allWeigthedResults; weightedResult];
%allWeigthedResults(counter, :) = weightedResult;


interval1 = linspace(0.1,0.7,61);
allWeightedResult = [];

for w1=interval1
    if (mod(w1,0.1) == 0)
        disp(num2str(w1));
    end

    for w2=interval1
        for w3=interval1
            for w4=interval1
                averageDistAll = [];
                
                
                if (w1+w2+w3+w4 > 1.0)
                    continue;
                end
                for i=1:10
                    averageDistAll = [averageDistAll; [distAll(i,:) .* [w1, w2, w3, w4]]];
                end
                weightedDistAll = sum(averageDistAll')';
                weightedDistAll = [weightedDistAll, expertResults];
                corrDist = corr(weightedDistAll);
                corrB = corrDist(2);
                weightedResult = [w1, w2, w3, w4, corrB];
                fprintf(dataFile, '%f, %f, %f, %f -> %f\n', weightedResult); 
                allWeightedResult = [allWeightedResult; weightedResult];
                
             end
        end
    end
end
distResults = 0; %öylesine koydum.

WR = allWeightedResult;
toc;
fprintf(dataFile, '%s\n', datestr(now));
dataFile2 = fopen('/home/tyra/data/Res/Process1/WeigtedResSorted.txt', 'a+');
newRows = sortrows(WR, 5);
fprintf(dataFile2, '%f, %f, %f, %f, %f\n', newRows');
dataFile3 = fopen('/home/tyra/data/Res/Process1/All of the works Completed', 'a+');
fclose(dataFile); fclose(dataFile2); fclose(dataFile3);

cd(oldPath);

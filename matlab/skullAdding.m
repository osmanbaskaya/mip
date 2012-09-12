function [brainSkull, distResults] = skullAdding (suffix, path)

% NOT_1: Bu fonksiyon daha tamamlanmadı ve bazı işleri iki yapıyor!!
% AtrophyCalc1, AtrophyCalc duzeltilmesi gerek.
% SKULLADDING  Provides an  cranial atrophy calculation.
%
% SYNOPSIS:
%     skullAdding('proportion_of_the_file_name', ['path'])
%
% DESCRIPTION:
%    This function helps to calculate cranial atrophy of that brain.
%    To do this, function needs specific slice of a preprocessed* brain, and
%    the cranium image. 
%    Moreover, function supports regular expression while sending
%    file name.
%    Function accepts one (at least one which interest in file name),
%    or two parameters.
%    Default path is result of !pwd.
%
%    [*] preprocessed: This function needs output of the FAST (FMRIB tool)   
%
%
%  CALL EXAMPLES :
%   [brainSkull] = skullAdding('haciahmet','/home/tyra/data/brains');
%
%  brainSkull is the image which has the cranium. 
%  
%  NOT_2: Polar Koordinat ekseni 1-2 bolge arasinda basliyor ve
%       counter-clockwise yonunde doğru açı tarıyor.
%
%  Author(s): Osman Baskaya <osman.baskaya@computer.org>
%  $Date: 2010/11/20

%tic
%% Get the Data
close all
clc
% if nargin == 1
%     path = cd;
% elseif nargin > 2
%     fprintf('wrong number of arg');
%     return
% end

fprintf('\n\n%s\n\n','******  NEW: Cranium Distances ******');
[my_str, oldPath] = getData(suffix, path);

%% Skull Adding

cranialResults = [];
hemisResults = [];
distAll = [];
patientName = [];

for k=1:length(my_str)
    dataName = my_str(k).name;
    fprintf('%i) Data is %s\n', k, dataName );
    [destIm1, sulcal1, hemisDist] = atrophyCalc1(dataName, '~/data/brains');
    [destIm, sulcal, hemisDist1] = atrophyCalc(dataName, '~/data/brains');
    cd('~/data/skulls1');
    outSkull = imread(dataName);
    outSkull = outSkull(:,:,1);
    outSkull = bwfill(outSkull);
    outSkull = bwperim(outSkull, 8);
    skullRadius = calculateSkullRadius(outSkull);
    %imshow(outSkull);
    brainSkull = or(outSkull,destIm);
    imshow(brainSkull);

    %end

    % Translation & Transformation

    [w, h] = size(brainSkull);
    centralPoint = [w/2, h/2]; % Central point of our brain.
    [x, y] = find(brainSkull == 1);
    x = x - centralPoint(1); % translation for x axis.
    y = y - centralPoint(2); % translation for y axis.
    hold on, plot(centralPoint(2), centralPoint(1), 'ro') % Central Point.

    [p_x, p_y] = cart2pol(x,y);

    % Some Constants:
    INCR = 0.0186; % 5 degree = 0.0436 Radian, def: 0.0236
    TOL = 0.0150; % ~ 1 degree.
    BOUNDRY = 0.3; % Taramayacak bu degerleri. default = 0.3
    PSEUDODIST = 3.0; %Pseudo-Distance, default = 6
    passHalf = 0; % For lower boundry.

    % Calculation

    i = min(p_x) + BOUNDRY - 0.05; % Starting Criteria : the least angle value.
    j = max(p_x) - BOUNDRY; % Stopping Criteria : the largest angle value.

    PointArr = [];  % For drawing.
    numberOfLine = 0;
    totalLineLength = 0;

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

            %Is this a Pseudo-Distance?
            currDist = abs(cranialPoint(2) - lastCelPoint(2));
            if currDist > PSEUDODIST

                % && ... We can also put a threshold for points which
                % are besides the cranialPoint. But not necessary now.
                drawPoints = [cranialPoint; lastCelPoint];
                [nx,ny] = pol2cart(drawPoints(:,1), drawPoints(:,2));
                ny = ny+centralPoint(2);
                nx = nx+centralPoint(1);
                plot(ny, nx,'g');
                currLineLength = sqrt((nx(1) - nx(2))^2 + (ny(1) - ny(2))^2);
                totalLineLength = totalLineLength + currLineLength;
                PointArr = [PointArr; drawPoints];
                numberOfLine = numberOfLine + 1;
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

        %         if (i > -BOUNDRY) && passHalf == 0
        %             i = (i + BOUNDRY);
        %             passHalf = 1;
        %         end
        i = i + INCR;
    end
    %imwrite(outSkull, dataName, 'png'); "imwrite denemek icin ekledim"

    averageLineDistance = (totalLineLength / numberOfLine) / skullRadius;
    fprintf('\n***Cranial distance Calculation***\n\n');
    fprintf('Length of the all lines is %i\n', totalLineLength);
    fprintf('Number of line is %i\n', numberOfLine);
    fprintf('Radius of the Cranium is %i\n', skullRadius);
    fprintf('Average-distance is %f\n\n', averageLineDistance);
    %toc
    %cranialResults = [cranialResults; averageLineDistance];
    %hemisResults = [hemisResults; hemisDist];
    hemisDist{1,2} = hemisDist{1,2}/skullRadius;
    distAll = [distAll; [hemisDist{1,2}, averageLineDistance]];


end
%cons = [deger, deger, deger, deger]';
%testRes = [testRes; [cons, distAll]];
if strcmp(suffix, 'sulcal')
    expertResults = [5,4,6,6,6,5,6,8,6,5]';
else
    expertResults = [];
end
%distResults = [distAll, distAll(:,1)+distAll(:,2) expertResults, [1:10]' ];
cd(oldPath);

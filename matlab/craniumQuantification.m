function [brainSkull, distResults, patients] = craniumQuantification ...
    (suffix, path, option)
% CRANIUMQUANTIFICATION Provides an  cranial atrophy calculation.
%
%   Problemler var. Iki kere calisma var bi fonk.
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
%   [brainSkull, distRes, p] = craniumQuantification('haciahmet', '/home/tyra/data/brains', 'noverbose');
%
%  brainSkull is the image which has the cranium.
%  Author(s): Osman Baskaya <osman.baskaya@computer.org>
%  $Date: 2012/02/20



DEPLOYPATH = '/home/tyr/Documents/datasets/mipdatasets/';

%% Get the Data
%close all
clc
% if nargin == 1
%     path = cd;
% elseif nargin > 2
%     fprintf('wrong number of arg');
%     return
% end
full_path = strcat(DEPLOYPATH, 'brains/', path);
if (strcmp(option, 'verbose'))
    fprintf('\n\n%s\n\n','******  NEW: Cranium Distances ******');
end
[my_str, oldPath] = getData(suffix, full_path);
scores = getScores(path);

%% Skull Adding

%cranialResults = [];
%hemisResults = [];
distAll = [];
patientList = java.util.HashMap;
expert_scores = [];

number_of_data = length(my_str);
for k=1:number_of_data
    dataName = my_str(k).name;
    current_score = scores.get(dataName);
    patientList.put(dataName, current_score);
    expert_scores = [expert_scores; current_score];
    fprintf('%i) Data is %s\n', k, dataName );
    [destIm1, sulcal1, hemisDist] = atrophyCalc1(dataName, full_path, option);
    [destIm, sulcal, hemisDist1] = atrophyCalc(dataName, full_path, option); % For Cortical Part
    %cd('/home/tyr/Programs/matlab/Data/skulls/unutkanlik'); % Path that contains skull images.
    

    
    
    cd(strcat(DEPLOYPATH, 'skulls/', path)); % Path that contains skull images.
    outSkull = imread(dataName);
    outSkull = outSkull(:,:,1);
    skullRadius = calculateSkullRadius(outSkull);
    %imshow(outSkull);
    brainSkull = or(outSkull, destIm); 
    if (strcmp(option, 'verbose'))
        
        if strmatch(path, 'miccai12')
            cd(strcat(DEPLOYPATH, 'raw_brains/', path));
            sulcal1 = imread(dataName);
        end
      imshow(sulcal1); 
        %figure, imshow(brainSkull), 
        hold on
    end
    
    %end
    
    % Translation & Transformation
    
    [w, h] = size(brainSkull);
    centralPoint = [w/2, h/2]; % Central point of our brain.
    [x, y] = find(brainSkull == 1);
    x = x - centralPoint(1); % translation for x axis.
    y = y - centralPoint(2); % translation for y axis.
    
    
    if (strcmp(option, 'verbose'))
        hold on, plot(centralPoint(2), centralPoint(1), 'ro') % Central Point.
    end
    [p_x, p_y] = cart2pol(x,y);
    
    % Some Constants:
    INCR = 0.01; % 5 degree = 0.0436 Radian, def: 0.0236
    TOL = 0.0150; % ~ 1.66 degree.
    if (w < 400)
        TOL = TOL * 2;
    end
    BOUNDRY = 0.3; % Taramayacak bu degerleri. default = 0.3
    PSEUDODIST = 3.0; %Pseudo-Distance, default = 6
    passHalf = 0; % For lower boundry.
    
    % Calculation
    
    i = min(p_x) + BOUNDRY - 0.05; % Starting Criteria : the least angle value.
    j = max(p_x) - BOUNDRY; % Stopping Criteria : the largest angle value.
    
    %PointArr = [];  % For drawing.
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
    
    averageLineDistance = (totalLineLength / numberOfLine) / skullRadius;

    if (strcmp(option, 'verbose'))
        fprintf('\n***Cranial distance Calculation***\n\n');
        fprintf('Length of the all lines is %i\n', totalLineLength);
        fprintf('Number of line is %i\n', numberOfLine);
        fprintf('Radius of the Cranium is %i\n', skullRadius);
        fprintf('Average-distance is %f\n\n', averageLineDistance);
    end
    %cranialResults = [cranialResults; averageLineDistance];
    %hemisResults = [hemisResults; hemisDist];
    hemisDist{1,2} = hemisDist{1,2}/skullRadius;
    distAll = [distAll; [hemisDist{1,2}, averageLineDistance]]; 
end
%cons = [deger, deger, deger, deger]';
%testRes = [testRes; [cons, distAll]];
if (strcmp(suffix, 'sulcal'))
    %expertResults = [5,4,6,6,6,5,6,8,6,5]'; %Bayindir Hast.
    %expertResults = [1,2,3,4,5,6,7,8]';      %Yue
else
    expertResults = [];
end
%distResults = [distAll, distAll(:,1)+distAll(:,2) expertResults,
%[1:length(expertResults)]' ];

distResults = [[1:number_of_data]', distAll, distAll(:,1)+distAll(:,2) expert_scores];
patients = patientList;
cd(oldPath);

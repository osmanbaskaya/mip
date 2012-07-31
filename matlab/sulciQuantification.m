function allDepths = sulciQuantification(suffix, path, option)
%SULCIQUANTIFICATION This function helps to quantify length of important 
%   sulci and fissure such as central-sulcus and sylvian fissure.
%   
%   Sylvian fissure part has not been implemented yet.
%
%   Author(s): Osman Baskaya <osman.baskaya@computer.org>
%   Date: 2012/05/14

DEPLOYPATH = '~/Documents/datasets/mipdatasets/';
load LaplaceStruct

%% Semi-Automated

% seed points for left and right hemispheres
seeds = {[115, 330, 288, 324], ...
         [128, 312, 276, 292], ...
         [141, 312, 333, 295], ...
         [88, 197, 204, 202], ...
         [142, 307, 286, 296], ...
         [86, 169, 158, 160], ...
         [57, 154, 122, 180], ...
         [83, 165, 146, 162], ...
         };
     
     
% 1px - 1mm
%ref datasets:
% image_size = [0.42968, 0.41015, 0.4453, 0.6875, 0.41015, ...
%                                         0.8789, 0.8789, 0.8203 ];

%miccai12
image_size = [0.4453, 0.6875, 0.41015, 0.42968, 0.6562, 0.8203, 0.4101];

%% Get Data
full_path = strcat(DEPLOYPATH, 'brains/', path);
if (strcmp(option, 'verbose'))
    fprintf('\n\n%s\n\n', '****** Sulci Quantification ******');
end

[my_str, oldPath] = getData(suffix, full_path);
scores = getScores(path);

%patientList = java.util.HashMap;
expert_scores = [];
number_of_data = length(my_str);

allDepths = zeros(number_of_data, 2);

for k=1:number_of_data
    dataName = my_str(k).name;
    current_score = scores.get(dataName);
    %patientList.put(dataName, current_score);
    expert_scores = [expert_scores; current_score];
    fprintf('%i) Data is %s\n', k, dataName );
    
%% Read Data
    I = imread(dataName);
    I = I(:,:, 1);
    
%% Laplacian Approach
    %LapI = calculateLaplaceBrain(I, 1); 
    
    % We have LaplaceStruct! 
    % Tum beyinlerin Laplace Equation'larini cozen fonksiyon:
    % getAllLaplacian.m
    % Ref haric goruntuler icin LapI tekrar hesaplanmali.
    LapI = LaplaceStruct.LapIs{k};
    [Nx, Ny] = getNormalVectorsOfLaplacian(LapI);
    
%% Sulcal Depth Calculation
    
    seedPoints = seeds{k}; % four points, for left and right hemispheres.
    close all
    imagesc(Nx); colorbar; title('Normal x-dir');
    hold on;
    color = '--g';
    [depthLeft, curvePathLeft] = getSulcalDepth(seedPoints(1:2), Nx, Ny, color);
    [depthRight, curvePathRight] = getSulcalDepth(seedPoints(3:4), Nx, Ny, color);
    allDepths(k, :) = [depthLeft, depthRight] * image_size(k);
    
    
end

cd(oldPath);
end
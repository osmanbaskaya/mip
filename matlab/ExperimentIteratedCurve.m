function allPathLengths = ExperimentIteratedCurve(suffix, path, slice_num, option)

% This is not yet another sulci quantification function!
% This function for displaying the iterative method.

% Author(s): Osman Baskaya <osman.baskaya@computer.org>
% Date: 2012/05/18

DEPLOYPATH = '/home/tyr/Documents/datasets/mipdatasets/';

%% Semi-Automated

% seed points for left and right hemispheres

% the seeds below is for 'ref' dataset.
% seeds = {[103, 343, 286, 320], ... % alidemir
%          [133, 312, 275, 292], ... % baharpelin
%          [307, 312, 138, 312], ... % erdalayhan
%          [88, 198, 203, 193], ...  % mahirerburhan
%          [157, 301, 287, 296], ... % nesrinIrgi
%          [86, 169, 161, 157], ...  % ozlemaliyilmaz
%          [75, 164, 123, 166], ...  % turgut
%          [83, 165, 146, 162], ...  % turkangencoglu
%          };
 
image_size = [0.42968, 0.41015, 0.4453, 0.6875, 0.41015, ...
                                        0.8789, 0.8789, 0.8203 ];


% the seeds below is for 'miccai12' dataset.

seeds = {[186, 353, 276, 335] ... %nesrin (x1,y1; x2, y2 for right)
         [81,167,151,161]...
         [174, 336, 260, 323] ... %erdal ayhan
         [88, 198, 203, 193], ...  % mahirerburhan
         [157, 301, 287, 296], ... % nesrinIrgi
         [132, 290, 293, 300], ...  % NuranAydinoglu
         [70, 195, 164, 197], ... % ServetDemirel
         [83, 165, 146, 162], ...  % TurkanGencoglu
         [103, 342, 293, 320], ...  % YukselIlk
         };
     
allPathLengths = [];

%% Get Data
full_path = strcat(DEPLOYPATH, 'brains/', path);
if (strcmp(option, 'verbose'))
    fprintf('\n\n%s\n\n', '****** Sulci Quantification ******');
end

my_str = getData(suffix, full_path);


%patientList = java.util.HashMap;
number_of_data = length(my_str);

for k=1:number_of_data
    
    dataName = my_str(k).name;
    fprintf('%i) Data is %s\n', k, dataName );
    
%% Read Data
    I = read_mri(dataName, full_path);
    I = I(:,:, slice_num(k));
    I = imrotate(I, 90); % correct orientation.
    
    
%% Iterated Version of Curve Calculation
    seedPoints = seeds{k}; % four points, two for left and two for right hemispheres.
    [left, right, C] = iteratedCurvePathFinder(I, seedPoints);
    
%% Displaying the Image


L = I > 1;
L = bwperim(L);
Lconv = bwperim(bwconvhull(L));
imshow(mat2gray(I>1) + Lconv + C)
[pathLeft, lengthLeft] =  getShortestPath(left);
[pathRight, lengthRight] =  getShortestPath(right);


% cd(strcat(DEPLOYPATH, '/raw_brains/miccai12'));
% P = imread(dataName);
% cd('/home/tyr/Programs/matlab12a/Library/MIP/figures/miccai12');
% L = I > 1;
% L = bwperim(L);
% Lconv = bwperim(bwconvhull(L));
% P(L > 0) = 255;
% S = P(:,:,2);
% S(C>0) = 250;
% P(:,:,2) = S;
% 
% S = P(:,:,3);
% S(Lconv) = 220;
% P(:,:,3) = S;
% P(165, 83, 2) = 250;
% P(164, 84, 2) = 250;
% P(164, 85, 2) = 250;
% P(162, 146, 2) = 250;
% P(162, 145, 2) = 250;
% P(163, 144, 2) = 250;
% figure, imshow(P), title(dataName); hold on;
% [pathLeft, lengthLeft] =  getShortestPath(left);
% [pathRight, lengthRight] =  getShortestPath(right);
% allPathLengths = [allPathLengths; [lengthLeft, lengthRight]];
% plot(pathLeft(:,1), pathLeft(:,2), '--r', 'LineWidth', 2);
% plot(pathRight(:,1), pathRight(:,2), '--r', 'LineWidth', 2);
% saveas(gcf, strcat(dataName(1:end-4), 'showcase.fig'));
% %close all;
% 
% S = P(:,:,1);
% S(C>0) = C(C>0) + 100;
% figure, imagesc(S);
% saveas(gcf, strcat(dataName(1:end-4), 'SC.fig'));
% close all;
% cd(full_path)
end

cd(oldPath);
end

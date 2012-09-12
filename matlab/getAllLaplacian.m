function LaplaceStruct = getAllLaplacian(suffix, path)
% GETALLLAPLACIAN Calculates all Laplace's equation of images.
%   You need to save this struct (LaplaceStruct) if you do not want to
%   calculate again.
%
%   Author: Osman Baskaya <osman.baskaya@computer.org>
%   Date: 22/05/2012


DEPLOYPATH = '/home/tyr/Programs/matlab12a/Data/';
%% Get Data
full_path = strcat(DEPLOYPATH, 'brains/', path);
fprintf('%s\n\n', '#### Function: All Laplacian ####');
tic

[my_str, oldPath] = getData(suffix, full_path);

number_of_data = length(my_str);

LaplaceStruct = struct();
LaplaceStruct.LapIs = {};
LaplaceStruct.dataNames = {};

for k=1:number_of_data
    
%% Read Data
    
    dataName = my_str(k).name;
    fprintf('%i) Data is %s\n', k, dataName );
    I = imread(dataName);
    I = I(:,:, 1);
    LaplaceStruct.dataNames = {LaplaceStruct.dataNames{1:end}, dataName};
    
    
    % Laplacian Approach
    LapI = calculateLaplaceBrain(I);
    LaplaceStruct.LapIs = {LaplaceStruct.LapIs{1:end}, LapI};
end
toc

cd(oldPath);
end



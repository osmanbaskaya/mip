function LaplaceStruct = getAllLaplacian(suffix, path)

tic
DEPLOYPATH = '/home/tyr/Programs/matlab12a/Data/';

%% Get Data
full_path = strcat(DEPLOYPATH, 'brains/', path);
fprintf('%s\n\n', '#### Function: All Laplacian ####');


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


cd(oldPath);
    
toc
end



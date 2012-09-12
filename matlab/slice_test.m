function slice_test()

% Tek bir slice icin yazilan testler.

%% Some Initialization

% Slice Test for IHA and HCA

clear
close all

IMAGE_PATH = '~/Documents/datasets/mipdatasets/test_images';
fileID = fopen('~/Desktop/results1.txt', 'w+');

%% Tests No:1

% Dataset: 'register/alidemir'
% Perfect Registration (Her hasta icin tek bir kesit)

dataset = 'register/alidemir';
path = strcat(IMAGE_PATH, '/', dataset, '/');

fprintf(fileID, 'TEST RESULTS: %s\n\n', dataset);

for slice_num=20:35

    close all
    cd(path);
    folder = int2str(slice_num);
    try
        cd(folder);
    catch err
        mkdir(folder);
        cd(folder);
    end


    D = atrophy_quantification('nii', dataset, slice_num, 'verbose');
    %write_all_scores(fileID, D, slice_num)

end
%% Test No:2

% Dataset: 'register/MNI/1mm'
% Perfect Registration (Her hasta icin tek bir kesit)

dataset = 'register/MNI/1mm';
path = strcat(IMAGE_PATH, '/', dataset, '/');

fprintf(fileID, '\n\nTEST RESULTS: %s\n\n', dataset);

for slice_num=107:141
    
    close all
    cd(path);
    folder = int2str(slice_num);
    try
        cd(folder);
    catch err
        mkdir(folder);
        cd(folder);
    end
    
    D = atrophy_quantification('nii', dataset, slice_num, 'verbose');
    %D = atrophy_quantification('mahir', dataset, 124, 'verbose');
    %write_all_corr_scores(fileID, D, slice_num)
    
    
    
end

%% Test No:3

% Dataset: 'register/MNI/alidemir/1mm'
% Perfect Registration (Her hasta icin tek bir kesit)

dataset = 'register/MNI/alidemir/1mm';
path = strcat(IMAGE_PATH, '/', dataset, '/');

fprintf(fileID, '\n\nTEST RESULTS: %s\n\n', dataset);

for slice_num=100:140
    
    close all
    cd(path);
    folder = int2str(slice_num);
    try
        cd(folder);
    catch err
        mkdir(folder);
        cd(folder);
    end
    
    D = atrophy_quantification('nii', dataset, slice_num, 'verbose');
    write_all_corr_scores(fileID, D, slice_num)
end

end



function write_all_corr_scores(fileID, D, slice_num)

% Data
IHA = D(:,2);
HCA = D(:,3);
Total = D(:,4);
expert_scores = D(:,5);


fprintf(fileID, 'Slice %d\n\tInterhemispherical Atrophy\n', slice_num);


[corr_IHA_K, num] = get_correlation(IHA, expert_scores, 'Kendall');
fprintf(fileID, '\t\tKendall Score: %.10f, Number of Sample:%d\n', corr_IHA_K, num);
[corr_IHA_P, num] = get_correlation(IHA, expert_scores, 'Pearson');
fprintf(fileID, '\t\tPearson Score: %.10f, Number of Sample:%d\n', corr_IHA_P, num);

fprintf(fileID, '\tHemispherical Cortical Atrophy\n');
[corr_HCA_K, num] = get_correlation(HCA, expert_scores, 'Kendall');
fprintf(fileID, '\t\tKendall Score: %.10f, Number of Sample:%d\n', corr_HCA_K, num);

[corr_HCA_P, num] = get_correlation(HCA, expert_scores, 'Pearson');

fprintf(fileID, '\t\tPearson Score: %.10f, Number of Sample:%d\n\n', corr_HCA_P, num);

end





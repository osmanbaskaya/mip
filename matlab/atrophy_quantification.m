function [distResults, patients] = atrophy_quantification ...
    (suffix, data_path, slice_num, option)
% CRANIUMQUANTIFICATION Provides an  cranial atrophy calculation.
%
%   
% SYNOPSIS:
%     atrophy_quantification('gz','registered/0.5mm', 'reg', 'noverbose')
%     craniumQuantification('png','yue', 'yue', 'noverbose')
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

%% Definition of some constants and setting some options

DATASET_PATH = '/home/tyr/Documents/datasets/mipdatasets/';
BRAIN_PATH = 'fast/';
SKULL_PATH = 'skulls/';

format long


%% Get the Data
%close all
%clc
% if nargin == 1
%     path = cd;
% elseif nargin > 2
%     fprintf('wrong number of arg');
%     return
% end

brain_full_path = strcat(DATASET_PATH, BRAIN_PATH, data_path);
skull_full_path = strcat(DATASET_PATH, SKULL_PATH, data_path);
if (strcmp(option, 'verbose'))
    fprintf('\n\n%s\n\n','******Atrophy Quantification******');
end

image_files = getData(suffix, brain_full_path);
number_of_data = length(image_files);

%% Slice check

if length(slice_num) == 1
    slice_num = repmat(slice_num, 1, number_of_data);
else
    if length(slice_num) ~= number_of_data
        error('Length of slice array is not equal length of the number_of_data');
    end
end


%% Atrophy Quantification

D = [];
patients = java.util.HashMap;
expert_scores = zeros(number_of_data, 1);

for k=1:number_of_data
    
    % Get the name of the data in image_files by one by.
    dataname = image_files(k).name;
    current_patient_score = get_patient_exp_score(dataname);
    patients.put(dataname, current_patient_score);
    expert_scores(k) = current_patient_score;
    
    fprintf('%i) Data is %s\n', k, dataname);
    
    % Read Betsurf output and related slice.
    skull = read_mri(dataname, skull_full_path);
    skull = skull(:,:, slice_num(k));
         
    % Read Fast output and related slice.
    FAST_brain = read_mri(dataname, brain_full_path);
    FAST_brain = FAST_brain(:,:, slice_num(k));
    
    % Evaluate the IHA and HCA
    hemisDist = eval_IHA(FAST_brain, skull, dataname, 800, option);
    cortDist = eval_HCA(FAST_brain, skull, dataname, 25, option);
    
    D = [D; [hemisDist, cortDist]]; 
end
distResults = [(1:number_of_data)', D, D(:,1)+D(:,2), expert_scores];
end


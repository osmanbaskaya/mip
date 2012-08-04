function score = get_patient_exp_score(dataName)
%GET_PATIENT_EXP_SCORE This function gets the patient's visual
%   assessment score to be decided by experts.   
%
%   Author: Osman Baskaya
%   Date: 03/08/2012

score = -1; % initial. score should not be -1.

%% Experts' Scores

patients = {{'MahirErburhan', 7}, ...
            {'bahar', 5}, ...
            {'baharhede', 5}};

%% Check the patient's score.

for k=1:length(patients)
    [patient_name, patient_score] = patients{k}{:}; 
    if strfind(dataName, patient_name)
        score = patient_score;
        break;
    end
end

%% Check some Error

%If the patient is not our patients list. Error will be occured.
if score == -1
    error('Patient is not in our patient score list. Please add it.')
end


end
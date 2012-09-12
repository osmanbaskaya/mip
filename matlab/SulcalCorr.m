% manualDepths comes from 

% 1px - 1mm
image_size = [0.4453, 0.6875, 0.41015, 0.42968, 0.6562, 0.8203, 0.4101];
                                    
miccai12= [7, 4, 3, 2, 1, 8, 5] ;                          
total = d + manuelDepths;
ultimateDistances(:,1) = image_size' .* total(:,1);
ultimateDistances(:,2) = image_size' .* total(:,2);  
ultimateDistances(:,3) = miccai12';


[left_corrK, signLeftK] = corr(ultimateDistances(:,1), ultimateDistances(:,3), ...
                                               'type', 'Kendall');
[right_corrK, signRightK] = corr(ultimateDistances(:,2), ultimateDistances(:,3), ...
                                                'type', 'Kendall');
[total_corrK, signTotalK] = corr(ultimateDistances(:,1) + ultimateDistances(:,2), ...
                                   ultimateDistances(:,3), 'type', 'Kendall');
                               
[left_corrP, signLeftP] = corr(ultimateDistances(:,1), ultimateDistances(:,3), ...
                                               'type', 'Pearson');
[right_corrP, signRightP] = corr(ultimateDistances(:,2), ultimateDistances(:,3), ...
                                                'type', 'Pearson');
[total_corrP, signTotalP] = corr(ultimateDistances(:,1) + ultimateDistances(:,2), ...
 ultimateDistances(:,3), 'type', 'Pearson'); 

allRes = [left_corrK, signLeftK;
    right_corrK, signRightK;
    total_corrK, signTotalK;
    left_corrP, signLeftP;
    right_corrP, signRightP;
    total_corrP, signTotalP];
                               
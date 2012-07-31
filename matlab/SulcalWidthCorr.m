%SULCALWIDTHCORR this procedure provides some results. 
%   Data such as manualWidthL comes from other prosedures named ...
%   
%   Author: Osman Baskaya

% 1px - 1mm
image_size = [0.4453, 0.6875, 0.41015, 0.42968, 0.6562, 0.8203, 0.4101];                    

% Expert Ratings
miccai12= [7, 4, 3, 2, 1, 8, 5]';


leftWidth = manualWidthL .* repmat(image_size, 3, 1)';
rightWidth = manualWidthR .* repmat(image_size, 3, 1)';
totalWidth = leftWidth + rightWidth;

rightWidth(:,4) = miccai12;
leftWidth(:,4) = miccai12;
totalWidth(:,4) = miccai12;

leftAvgCorrK = corr(leftWidth(:,1), miccai12, 'type', 'Kendall');
leftMeanCorrK = corr(leftWidth(:,2), miccai12, 'type', 'Kendall');
leftMaxCorrK = corr(leftWidth(:,3), miccai12, 'type', 'Kendall');
leftAvgCorrP = corr(leftWidth(:,1), miccai12, 'type', 'Pearson');
leftMeanCorrP = corr(leftWidth(:,2), miccai12, 'type', 'Pearson');
leftMaxCorrP = corr(leftWidth(:,3), miccai12, 'type', 'Pearson');

rightAvgCorrK = corr(rightWidth(:,1), miccai12, 'type', 'Kendall');
rightMeanCorrK = corr(rightWidth(:,2), miccai12, 'type', 'Kendall');
rightMaxCorrK = corr(rightWidth(:,3), miccai12, 'type', 'Kendall');
rightAvgCorrP = corr(rightWidth(:,1), miccai12, 'type', 'Pearson');
rightMeanCorrP = corr(rightWidth(:,2), miccai12, 'type', 'Pearson');
rightMaxCorrP = corr(rightWidth(:,3), miccai12, 'type', 'Pearson');

totalAvgCorrK = corr(totalWidth(:,1), miccai12, 'type', 'Kendall');
totalMeanCorrK = corr(totalWidth(:,2), miccai12, 'type', 'Kendall');
totalMaxCorrK = corr(totalWidth(:,3), miccai12, 'type', 'Kendall');
totalAvgCorrP = corr(totalWidth(:,1), miccai12, 'type', 'Pearson');
totalMeanCorrP = corr(totalWidth(:,2), miccai12, 'type', 'Pearson');
totalMaxCorrP = corr(totalWidth(:,3), miccai12, 'type', 'Pearson');

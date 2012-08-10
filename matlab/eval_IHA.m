function hemisDist = eval_IHA(I, skull, dataname, min_size, option)
% SYNOPSIS:

% DESCRIPTION:
%  CALL EXAMPLES :
%  Author(s): Osman Baskaya <osman.baskaya@computer.org>
%  $Date: 2010/11/20

tic
if nargin > 5
    error('Wrong number of args.\n');
end

fprintf('\t-> IHA Evaluation: ');
I_extracted = extractHemispheres(I, min_size, option);

% rotation should be needed for nii.
I_extracted = imrotate(I_extracted, 90);

if (strcmp(option, 'verbose'))
    figure, imshow(I_extracted), title(dataname), hold on;
end


%Evaluate the Midline
midLineVec = findMidlineVec(I_extracted, option);
[~, hemisDist] = findHemisphericalDist(I_extracted, midLineVec, option);

if (strcmp(option, 'verbose'))
    saveas(gcf, strcat(dataname(1:end-4), 'IHA.png'))
end


% Normalization
skullRadius = calculateSkullRadius(skull);
hemisDist = hemisDist / skullRadius;
if (strcmp(option, 'verbose'))
    fprintf('\t\t- Normalized-Distance is %f\n\t', hemisDist);
end
toc
end
% h = imdistline(gca,[10 100], [100 100]);
% getDistance(h)
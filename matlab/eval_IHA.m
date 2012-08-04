function hemisDist = eval_IHA(I, skull, dataName, min_size, option)
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
    figure, imshow(I_extracted), title(dataName);
end
%Evaluate the Midline
if (strcmp(option, 'verbose'))
    hold on, %pixval on
end

midLineVec = findMidlineVec(I_extracted, option);
[~, hemisDist] = findHemisphericalDist(I_extracted, midLineVec, option);

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
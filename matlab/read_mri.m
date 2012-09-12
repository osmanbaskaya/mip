function I = read_mri(dataName, path)

% READ_MRI This function helps to read MRI Images. It can handle nii
% formated images and png images only for now. If you want to read
% a brain image. You need to use this function.
%
% Author: Osman Baskaya <osman.baskaya@computer.org>
% Date: 02/08/2012

data_name = strcat(path, '/', dataName);

if strfind(dataName, 'nii') % nii formated image
    I = read_nii(data_name);
else
    I = imread(data_name); % png-like images.
end


end
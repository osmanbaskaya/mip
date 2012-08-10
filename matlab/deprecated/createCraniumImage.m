function createCraniumImage (suffix, path, slice_num)
% CREATECRANIUMIMAGE Create preprocessed images for cranial atrophy quantification.
%
% SYNOPSIS :
%   createCraniumImage(suffix, path, slice_num)
% 
% DESCRIPTION :
%   Path should be original images which are outputs of FSL betsurf.
%   Output files is created in directory below:
%   cd('/home/tyra/data/skulls/yue'); % the place in which data should be written.
%
% CALL EXAMPLES :
%    createCraniumImage('img', '/home/tyra/data/skulls/originals/yue', 20)
%
% Author(s) : Osman Başkaya <osman.baskaya@computer.org>
% Date: 2010/03/20
% Last Revision: 2012/07/30 OsmanBaskaya

[data, oldPath] = getData(suffix, path);
for i=1:length(data);
    figure,
    dataName = data(i).name;
    fprintf('%i) Data is %s\n', i, dataName );
    outSkull = analyze75read(dataName);
    outSkull = outSkull(:, :, slice_num);
    outSkull = bwfill(outSkull);
    outSkull = bwperim(outSkull, 4);
    figure, imshow(mat2gray(outSkull));
    cd('/home/tyr/Programs/matlab12a/Data/skulls'); % the place in which data should be written.
    imwrite(outSkull, dataName, 'png');
    cd(path)
    close all
end


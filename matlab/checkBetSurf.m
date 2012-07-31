function checkBetSurf(suffix, path_raw, path_skulls)
%CHECKBETSURF
%
%Bu fonksiyon betsurf'un guvenirligini kontrol etmek icin yazildi.
%Orjinal data ile islenmis betsurf sonucunu ustuste oturtuyor.
%
%Example: checkBetSurf('png','/home/tyra/data/mri/yue', '/home/tyra/data/skulls/yue');
%Author: Osman Baskaya 
%Date: 27/05/2011

DEPLOYPATH = '/home/tyr/Programs/matlab/Data/';

[data, oldPath] = getData(suffix, path_raw);
[skulls, oldPath] = getData(suffix, path_skulls);
for i=1:length(data);
    cd(path_raw);
    figure,
    dataName = data(i).name;
    skullName = skulls(i).name;
    fprintf('%i) Now Processing %s\n', i, dataName );
    rawData = imread(dataName);
    cd(path_skulls);
    outSkull = logical(imread(skullName)); %Sonra bak 5172 logical olmuyor.
    % Soru : Devrim Hoca. -> Alttaki fonksiyon.
    rawData(outSkull) = 255;
    cd(strcat(DEPLOYPATH, 'checkbetsurf')); % the place in which data should be written.
    imwrite(rawData, dataName, 'png');
    close all
end

end

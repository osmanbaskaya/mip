%Image Merge: Cranium + BET Results
%Osman Baskaya
%Gorsellik icin bu sadece. Betin uzerine ekleme yaparak
%cranium kısmını daha iyi gorelim, doktorlara yollayalım diye

cd('/home/tyra/Desktop/sulc/')
close all
my_str = dir(['*','png','*']);

for i=1:length(my_str)
    betS = imread('/home/tyra/Desktop/haci_sulc.png');
    betV = imread('/home/tyra/Desktop/haci_ventr.png');
    fprintf('data: %s\n', my_str(i).name)
    I1 = imread(my_str(i).name);
    I1 = I1(:,:,1);
    betS(and(betS(:,:,3),I1)) = 255;
    imshow(I1);
end


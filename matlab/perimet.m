cd('/home/tyra/Desktop/ventr');

my_str = dir(['*','png','*']);

for i=1:length(my_str)
    betS = imread('/home/tyra/Desktop/koseoglu_ventr.png');
    data = my_str(i).name
    I1 = imread(data);
    I1 = I1(:,:,1);
    figure;
    bwI1 = bwfill(I1);
    %figure, imshow(bwI1)
    I1log = logical(I1);
    perimOut = bwperim(bwI1);
    %figure, imshow(perimOut)
    perimIn = bwperim(bwI1-I1log);
    %figure, imshow(perimIn)
    betS(and(betS(:,:,3),perimIn)) = 255;
    figure, imshow(betS);
    betS = imread('/home/tyra/Desktop/koseoglu_ventr.png');
    betS(and(betS(:,:,3),perimOut)) = 255;
    figure, imshow(betS);
    %     lastIn = or(betV,perimIn);
    %     figure, imshow(lastIn)
    %     lastOut = or(betV,perimOut);
    %     figure, imshow(lastOut);
end

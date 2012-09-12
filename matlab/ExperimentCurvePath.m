%% Experiment on Path of the Curve
%clear, clc
%load expPath

%close all
color = '--g';

seedPoints = [103, 343, 286, 320];

%seedPoints = [307, 312, 138, 312];

C = zeros(size(I));
jump = 10;
for i=1:1000
    
    [depthLeft, curvePathLeft] = getSulcalDepth(seedPoints(1:2), Nx, Ny, color);
    [depthRight, curvePathRight] = getSulcalDepth(seedPoints(3:4), Nx, Ny, color);
    LapI = EcalculateLaplaceBrain(I, LapI, jump);
    [Nx, Ny] = getNormalVectorsOfLaplacian(LapI);
    %imagesc(Nx); colorbar; title('Normal x-dir');
    if (isempty(curvePathLeft) || isempty(curvePathRight))
       fprintf('The last Laplace is %d\n', jump * i);
       break; 
    end
    idx = sub2ind(size(C), curvePathLeft(:,2), curvePathLeft(:,1));
    C(idx) = C(idx) + 1;
    idx = sub2ind(size(C), curvePathRight(:,2), curvePathRight(:,1));
    C(idx) = C(idx) + 1;
end

cd /home/tyr/Programs/matlab12a/Data/raw_brains/ref
P = imread(dataName);
%P = P(:,:,1);


L = I > 150;
L = bwperim(L);
Lconv = bwperim(bwconvhull(L));

P(L > 0) = 255;
S = P(:,:,2);
S(C>0) = 250;
P(:,:,2) = S;

S = P(:,:,3);
S(Lconv) = 220;
P(:,:,3) = S;
imshow(P)


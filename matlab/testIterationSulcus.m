%% Iteration Test for Calculation Sulcus Length

close all;
%seedPoints = [308, 312]; % For Erdal
color = '--g';
iter = 50;
LapI = calculateLaplaceBrain(I, iter);
[Nx, Ny] = getNormalVectorsOfLaplacian(LapI);
imagesc(Nx); colorbar; title('Normal x-dir');
hold on;
zoom on;
%seedPoints = [306, 312]; % For Erdal
seedPoints = [88 197];
color = '--b';
[depthRight, dirRight] = getSulcalDepth(seedPoints, Nx, Ny, color);

mask = [1 0 -1];

for x=mask
    for y=mask
        depthRight = getSulcalDepth(seedPoints + [x, y], Nx, Ny, color);
    end
end
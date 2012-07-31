function [Nx, Ny] = getNormalVectorsOfLaplacian(LapI)


% Compute Energy ( E = - Gradient[A] )
spacing = 1;
[Ex, Ey] = gradient(LapI, spacing);
Ex = -Ex;
Ey = -Ey;

% Compute normal ( N = E / ||E|| )
NormE = sqrt(Ex.^2 + Ey.^2);
Nx = Ex ./ NormE;
Ny = Ey ./ NormE;



% subplot(2,2,1), imagesc(LapI); colorbar; title('Potential (Phi)');
% subplot(2,4,2), imagesc(Ex); colorbar; title('Energy x-dir');
% subplot(2,4,3), imagesc(Ex); colorbar; title('Energy y-dir');
% subplot(2,2,2), imagesc(NormE); colorbar; title('Norm of Energy');
% subplot(2,2,3), imagesc(Nx); colorbar; title('Normal x-dir');
% subplot(2,2,4), imagesc(Ny); colorbar; title('Normal y-dir');

end
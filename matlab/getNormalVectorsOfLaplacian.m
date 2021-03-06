function [Nx, Ny, Nz] = getNormalVectorsOfLaplacian(LapI)
% GETNORMALVECTORSOFLAPLACIAN This function calculates and returns
%   normal vectors of a vector which obtained by solving Laplace's Eqn.
%   Given vector can be 2D or 3D. Distance metric is L2.
%   
%   Author: Osman Baskaya
%   Date: May 2012
%   Revision1: Sept 2012 - Adding 3D feature - Osman Baskaya


s = length(size(LapI));
Nz = 0;

% Compute Energy ( E = - Gradient[A] )
spacing = 1;
if s == 2
    [Ex, Ey] = gradient(LapI, spacing);
    Ex = -Ex;
    Ey = -Ey;
    
    % Compute normal ( N = E / ||E|| )
    NormE = sqrt(Ex.^2 + Ey.^2);
    Nx = Ex ./ NormE;
    Ny = Ey ./ NormE;
    
elseif s == 3 % Gradient calc in 3D
    [Ex, Ey, Ez] = gradient(LapI, spacing);
    Ex = -Ex;
    Ey = -Ey;
    Ez = -Ez;
    
    % Compute normal ( N = E / ||E|| )
    NormE = sqrt(Ex.^2 + Ey.^2 + Ez.^2);
    Nx = Ex ./ NormE;
    Ny = Ey ./ NormE;
    Nz = Ez ./ NormE;
end



% subplot(2,2,1), imagesc(LapI); colorbar; title('Potential (Phi)');
% subplot(2,4,2), imagesc(Ex); colorbar; title('Energy x-dir');
% subplot(2,4,3), imagesc(Ex); colorbar; title('Energy y-dir');
% subplot(2,2,2), imagesc(NormE); colorbar; title('Norm of Energy');
% subplot(2,2,3), imagesc(Nx); colorbar; title('Normal x-dir');
% subplot(2,2,4), imagesc(Ny); colorbar; title('Normal y-dir');

end
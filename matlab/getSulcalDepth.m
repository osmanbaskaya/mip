function [depth, directions] = getSulcalDepth(seedPoint, Nx, Ny, J, color)
% GETSULCALDEPTH Calculates the sulcal depth and all directions.
%
% Author: Osman Baskaya <osman.baskaya@computer.org>
% Date: 22/05/2012


directions = [];
depth = 0;
x = seedPoint(1);
y = seedPoint(2);

MAX_ITER = 1000;
for i=0:1:MAX_ITER
    a = Nx(y, x);
    b = Ny(y, x);
    
    if (isnan(a + b))
        break;
    end
    
    [rx, ry] = findDirections(a, b);
    new_x = x + rx;
    new_y = y + ry;
    if ~isempty(directions)
        if ~isempty(find(directions(:,1) == new_x & directions(:,2) == new_y, 1))
            break;
        end
    end
    
    if(J(new_y, new_x) == 1)
        break;
    end
    
    directions = [directions; [new_x, new_y]];
    %plot([x, new_x], [y, new_y], color) % color = --g like.
    x = new_x;
    y = new_y;
    
    % Goruntu Z yonunde isotrophic degil. O yuzden depth
    % hesabinda her koordinati mm'ye cevirmek gerekiyor!!! 
    depth = depth + sqrt(rx^2 + ry^2);
    
    if (i >= MAX_ITER)
        fprintf('Maximum iteration (%d) is exceeded.\n', MAX_ITER);
    end
    
end
end

%% Find Directions

function [rx, ry] = findDirections(x, y)

% Tekrar bak!!!

angle = atand(y/x);

if (angle > -22.5 && angle <= 22.5)
    rx = 1; ry = 0;
elseif (angle > 22.5 && angle <= 67.5)
    rx = 1; ry = 1;
elseif (angle > 67.5 && angle <= 90)
    rx = 0; ry = 1;
elseif (angle >-67.5 && angle <= -22.5)
    rx = 1; ry = -1;
elseif (angle >= -90 && angle <= -67.5) % 67.5 idi eskiden. Dogru mu??
    rx = 0; ry = -1;
end

if (x <= 0 && y <= 0) || (x < 0 && y >= 0)
    rx = -rx; ry = -ry;
end

end
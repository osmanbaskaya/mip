function depth = getSulcalDepth(x, y)
load res

depth = 0;
%imagesc(LapI); colorbar; title('Normal x-dir');
hold on;

while(1)
    a = Nx(y, x);
    b = Ny(y, x);
   if (isnan(a + b))
       break;
   end
    [rx, ry] = findDirections(a, b);
    
    depth = depth + sqrt(rx^2 + ry^2);
    new_x = x + rx;
    new_y = y + ry;
    plot([x, new_x], [y, new_y],'--g', 'LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',10);
    x = new_x;
    y = new_y;
end
end

%% Find Directions

function [rx, ry] = findDirections(x, y)

angle = atand(y/x);

if (angle > -22.5 && angle <= 22.5)
    rx = 1; ry = 0;
elseif (angle > 22.5 && angle <= 67.5) 
    rx = 1; ry = 1;
elseif (angle > 67.5 && angle <= 90) 
    rx = 0; ry = 1;
elseif (angle >-67.5 && angle <= -22.5)
    rx = 1; ry = -1;
elseif (angle >= -90 && angle <= 67.5)
    rx = 0; ry = -1;
end

if (x < 0 && y < 0) || (x < 0 && y > 0)
    rx = -rx; ry = -ry;
end

end
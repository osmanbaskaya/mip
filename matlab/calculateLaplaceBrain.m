function [LapI] = calculateLaplaceBrain (I, max_iter)

%load lap
I = I > 150; % removing all csf regions and other regions are 1 now.
%I = or(I, outSkull);
%I = bwperim(I, 8);

C = xor(bwperim(I, 8), I);
Conv = bwconvhull(I); %Convex Hull of I
Conv = bwperim(Conv, 8);


prev_I = NaN; % previous step of I
EPS = 0.001; % Stopping criterion 
enf_I = I; % original I. It will be enforced in the loop.


if (max_iter == 0)
    max_iter = Inf;
end
iteration = 0;
while (iteration < max_iter)
    iteration = iteration + 1;
    
    % enforce boundary condition.
    I(enf_I) = 1;
    I(Conv) = 0;
    I(C) = 0;
    
    if (mod(iteration, 100) == 0),
      imagesc(I);
      title(iteration);
      colorbar;
      drawnow;
      %iteration
    end
        
    c = sum(sum(abs(I - prev_I)));
    if (c < EPS)
        break;
    end
    
    
    % incrementally solve laplace's equation by setting every cell equal
    % to the average value of the neighboring cells    
    B = 0;
    for x=[-1 0 1]
        for y=[-1 0 1],
            if (x~=0 || y ~=0),
                B = B + circshift(I, [x y]);
            end
        end
    end
    prev_I = I;
    I = B/8;
end

LapI = I;

end

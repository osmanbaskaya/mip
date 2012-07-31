function [LapI] = EcalculateLaplaceBrain (I, LapJ, max_iter)

if isempty(LapJ)
   LapI = calculateLaplaceBrain(I, max_iter); 
   return;
end

%load lap
I = I > 150; % removing all csf regions and other regions are 1 now.

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
    LapJ(enf_I) = 1;
    LapJ(Conv) = 0;
    LapJ(C) = 0;
    
    if (mod(iteration, 100) == 0),
      imagesc(LapJ);
      title(iteration);
      colorbar;
      drawnow;
      %iteration
    end
        
    c = sum(sum(abs(LapJ - prev_I)));
    if (c < EPS)
        break;
    end
    
    
    % incrementally solve laplace's equation by setting every cell equal
    % to the average value of the neighboring cells    
    B = 0;
    for x=[-1 0 1]
        for y=[-1 0 1],
            if (x~=0 || y ~=0),
                B = B + circshift(LapJ, [x y]);
            end
        end
    end
    prev_I = LapJ;
    LapJ = B/8;
end

LapI = LapJ;

end

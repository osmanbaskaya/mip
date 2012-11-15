% Sept 2012


clear, clc
I = zeros(10,10,10);

prev_I = NaN; % previous step of I
EPS = 0.001; % Stopping criterion 
%enf_I = I; % original I. It will be enforced in the loop.

max_iter = 0;
if (max_iter == 0)
    max_iter = Inf;
end
iteration = 0;
while (iteration < max_iter)
    iteration = iteration + 1;
    
    % enforce boundary condition.
    I(2,:,:) = 1;
    I(3,5,5) = 1;
    I(1,:,:) = 0;
    I(:,1,:) = 0;
    I(:,end,:) = 0;
    
    %disp('==============');
    %I
    
    
    slice(I, 1, 1, 1:10);
    
        
    c = sum(sum(abs(I - prev_I)));
    if (c < EPS)
        break;
    end
    
    
    % incrementally solve laplace's equation by setting every cell equal
    % to the average value of the neighboring cells    
    B = 0;
    for x=[-1 0 1]
        for y=[-1 0 1]
            for z=[-1 0 1]
            if (x~=0 || y ~=0 || z ~= 0),
                B = B + circshift(I, [x y z]);
            end
            end
        end
    end
    prev_I = I;
    I = B/26;
end

%LapI = I;


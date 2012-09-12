function crLineIterative(cand, h, option)
% CRLINEITERATIVE Helps to draw midline.
%
% SYNOPSIS:
%    crLine(candidateXs, image_height)
%
% DESCRIPTION:
%    This function is used when findMidlineVec function cannot draw a
%    straight line for midline.
%

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>
%  Date: 2011/05/20


global line_; %declared in backT.m
global sourceImage; %declared in backT.m


x = cand(1);
y = cand(2);
line_ = [x y 0 0 0];

directions = {[1,0], [0, -1], [0, 1]};

processedPoints = [-1 -1]; % for dynamic programming.

pop = 0;
s = size(line_);
counter = 0;

while (1)
    counter = counter + 1;
    %plot(line_(end,2), line_(end,1), 'r')
    finish = line_(end, :);
    if (finish(1) > h-2)
        if (strcmp(option, 'verbose'))
            plot(line_(:,2), line_(:,1), 'y')
        end
        return
    end

    s = size(line_);
%     if (s(1)==630)
%        fprintf('The Line is now %d\nIt is too much for medial\n', s(1));
%        line_ = [x y-10 0 0 0];
%     end
   
    if(s(1) == 1 && pop == 1)
        disp('Verilen goruntude iki yarim kure arasinda bosluk yok.')
        error('Datayi modifiye etmelisiniz.');
    end

    if(pop == 1)
        pop = 0;
        processedPoints = [processedPoints; line_(end,1:2)];  
        %line_ = removerows(line_, s(1)); % Remove the last element.
		line_ = line_(1:end-1, :);
    end

    lastRow = line_(end, :);
    
    %direction
    
    if (lastRow(3) == 0)
        dirIndex = 1;
        compass = [0 0 0];
        line_(end, 3) = 1;
        lastRow(3)= 1;
    elseif (lastRow(4) == 0)
        dirIndex = 2;
        compass = [0 0 1];
        line_(end, 4) = 1;
        lastRow(4) = 1;
    elseif (lastRow(5) == 0)
        dirIndex = 3;
        compass = [0 1 0];
        line_(end, 5) = 1;
        lastRow(5) = 1;
    else
        pop = 1;
        continue;
    end
    

    nextRow = lastRow + [directions{dirIndex}, 0 0 0]; % son 3 deger onemsiz Asagida ezilecek.
    nextRow(3:end) = compass; 

    if (~isempty(find(processedPoints(:,1) == nextRow(1) & processedPoints(:,2) == nextRow(2), 1)))
        continue; % If we have passed this point before, we don't need to examine it again.
    end

   
    if(sourceImage(nextRow(1), nextRow(2)) == 1)
        processedPoints= [processedPoints; nextRow(1), nextRow(2)];
        continue;
    else
        line_ = [line_; nextRow];
        %plot(nextRow(2), nextRow(1),'xr');
    end

end
end



%function midLines = findMidlines (sourceIm, detail)
%This function is... useless!

[h, w] = size(sourceIm);
%Evaluate the Midline
hold on, %pixval on
deg = floor(w/2)-5;
%line = sourceIm(:,deg);
line2 = zeros(h,1);
midLineIndex = deg;

h0 = 1;

while h0 < h
    cand = [-1, -1]; % Initial values.
    total = -1;
    for i=deg:deg+10
        line = sourceIm(h0:end,i);
        total = sum(line);
        if total == 0
           line2(h0:end,1) = i;
           h0 = h;
           break;
        end
        temp = find(line,1); % Get the first nonzero element.
        if temp > cand(1)
           cand = [temp, i]; %temp-> y coord, i->x coord.
        end
    end

    if total ~= 0
        if h0 ~= 1
            line2(h0-1:end,1) = cand(2);
        else
            line2(h0:end,1) = cand(2);
        end
        h0 = cand(1) + h0 -2;
    end
    
    
end




%plotting for detailed version.
% if detail == 1
%     disp(['midLineIndex is ', num2str(midLineIndex)]);
%     disp(['number of overlap is ', num2str(sum(line))]);
%     plot([midLineIndex,midLineIndex], [0,h-1], 'r');
% end
% 
% midLines = midLineIndex;
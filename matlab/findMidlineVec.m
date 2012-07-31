function midLineVec = findMidlineVec(sourceIm, option)


% NAME:
%     findMidlineVec - This function provides a line which never
%     overlaps any white-matter, and gray-matter pixels.
%         
%
% SYNOPSIS:
%     atropyCalc('proportion_of_the_file_name', ['path'])
%
% DESCRIPTION:
%    This function provides a line which never overlaps any
%    pixels. But midline may be find. Because some brain
%

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>

%  $Date: 2010/11/20  



[h, w] = size(sourceIm);
global line_;
line_ = [];
global sourceImage;
sourceImage = sourceIm;


%Evaluate the Midline
if(strcmp(option,'verbose'))
    hold on, %pixval on
end
deg = floor(w/2)-10;
line2 = zeros(h,1);


h0 = 1;
cand = [-1, -1]; % Initial values.
total = -1;
for i=deg:deg+20
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

if total == 0
    midLineVec = [(1:h)', line2];
    if(strcmp(option,'verbose'))
        hold on
        %plot([outLine(1),outLine(1)],[1,h],'r');
    end
    return;

end

%backtracking:
%Problem:En temiz sekilde bi straight line ciziyor ve backtrack baslatiyor.
%ve daha sonra backtrack baslatılıyor.
%Cozum. Backtrack icin sadece o en uzun temiz line'ı parametre olarak yolla
% en bastan baslasın cizim....
line2(h0:cand(1),2) = cand(2);
line2(h0:cand(1)-1,1) = 1:cand(1)-1;
line2 = line2(1:cand(1)-1, 1:2);
n = cand(1)-1;
cand(1) = 1;
crLineIterative(cand, h, option);
%midLineVec = [line2; line_];
midLineVec = line_;






function crLine(cand, h)

% NAME:
%    crLine - Helps to draw midline. crLine can use backtracking approach.
%
% SYNOPSIS:
%    crLine(candidateXs, image height) 
%
% DESCRIPTION:
%    This function is used when findMidlineVec function cannot draw a
%    straight line for midline.
%
%Bug:  ismember([k,l], line_);
%Fix:  correct form is ismember([k,l], line_ 'rows'); 'rows' is important.

%  Author(s): Osman Baskaya <osman.baskaya@computer.org>

%  $Date: 2010/11/20
%Bug:  ismember([k,l], line_);
%Fix:  correct form is ismember([k,l], line_ 'rows'); 'rows' is important.

global line_; %declared in backT.m
global sourceImage; %declared in backT.m


x = cand(1);
y = cand(2);
line_ = [line_; [x,y]];

if ~isempty(line_)
  
    if line_(end,1) >= h
        return;
    end
end

directions = {[1,0], [0,-1], [0, 1]};

for i=1:length(directions)
    k = directions{i}(1) + x;%line(end, 1);
    l = directions{i}(2) + y;%line(end, 2);
    j = ismember([k,l], line_, 'rows');
    if ~ismember(0, j)
        continue;
    end
    if sourceImage(k,l) == 0
       crLine([k, l], h) 
    end
    
    %genelde aşağıdaki tarafa return koyulmuyor Python
    %ya da diger programlama dillerinde. ama diger
    %turlu hep hata alıyorum. 
    %DAHA SONRA TEKRAR BAK
    if line_(end,1) >= h
        return;
    end
end

line_ = line_(1:end-1,1:2);

end

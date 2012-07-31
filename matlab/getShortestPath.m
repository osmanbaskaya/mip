function [shortestPath, shortestPathLength] = getShortestPath(path)

%GETSHORTESTPATH This function calculates the shortest path and its length
%   of any path by using Dijkstra's Algorithm.
%
%   More information: http://en.wikipedia.org/wiki/Dijkstra's_algorithm
%
%   Author: Osman Baskaya <osman.baskaya@computer.org>
%   Date: 2012/05/28



shortestLength = Inf;
shortestPath = [];

G = initializeSingleSource(path);
K = [];
path_G = path;


curr = 1; % source index
while ~isempty(G)
    
    v = G(curr);
    n = getNeighbors(path_G, v);
    for i=1:length(n)
        u = G(n(i));
        dist = sqrt((u.x - v.x)^2 + (u.y - v.y)^2);
        total_dist = dist + v.d;
        if (u.d >= total_dist)
            u.d = total_dist;
            u.shortestV = v;
            G(n(i)) = u;
            G(curr) = v;
        end
        
    end
    
    K = [K; G(curr)];
    G(curr) = []; % remove it.
    path_G(curr, :) = [];
    curr = findNextVertex(G);
end

shortestPath = trackShortestPath(K);
shortestPathLength = K(end).d;

end

function G = initializeSingleSource(V)

%Source is considered the first element of V.

[r, ~] = size(V);
G = [];

for i=1:r
    v = struct();
    v.x = V(i, 1);
    v.y = V(i, 2);
    v.d = Inf;
    v.shortestV = NaN; %shortest vertex
    G = [G; v];
end
G(1).d = 0; % because this one is the source.

end



function neighbors_indexes = getNeighbors(path, v)

neighbors_indexes = [];
for i=-1:1
    for j=-1:1
        if ~(i == 0 && j == 0)
            s = [v.x + i, v.y + j];
            [~, index] = ismember(s, path, 'rows');
            if (index ~= 0)
                neighbors_indexes = [neighbors_indexes, index];
            end
        end
    end
end
end

function index = findNextVertex(G)

index = 0;
min_distance = Inf;
for i=1:length(G)
    v = G(i);
    if (min_distance > v.d)
        min_distance = v.d;
        index = i;
    end
end
end

function shortestPath = trackShortestPath(G)
% Warning: Shortest path direction is reverse now.

shortestPath = [];
v = G(end); % first (actually end) vertex

while (v.d ~= 0)
    
    shortestPath = [shortestPath; [v.x, v.y]];
    v = v.shortestV; 
end

% Don't forget to add source vertex ;)
shortestPath = [shortestPath; [G(1).x, G(1).y]];

    
end

function [my_str, oldPath] = getData(suffix, path)

oldPath = cd;
cd(path);

%suffix = 'png'; % (i.e. for all images)
my_str = dir(['*',suffix,'*']);
%fprintf('Path is %s\n\n', cd);

end
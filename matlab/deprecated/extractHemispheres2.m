function [destIm, sulcal] = extractHemispheres2 (dataName, option)

sulcal = imread(dataName);
sulcal = sulcal(:,:,1);
foo = sulcal;
foo(sulcal < 150) = 0;
n_foo = bwperim(foo);
[L,num] = bwlabel(n_foo);
if (strcmp(option, 'verbose'))
    disp(['Number of Labels is ', num2str(num)]);
end
%figure, imshow(n_foo);

%cleaning of redundant objects.
c = num;
[h, w] = size(n_foo);
newIm = zeros(h,w);
wholeObj = bwlabel(n_foo);
for j=1:num
    currObj = (wholeObj == j);
    k = find(currObj == 1);
    L = length(k);
    %sum(sum(currObj));
    if L <= 300;
    else
        newIm(k) = 1;
    end
end

%[r,c] = bwlabel(n_foo);
%figure, imshow(n_foo);

%destIm = n_foo;
destIm = newIm;
end
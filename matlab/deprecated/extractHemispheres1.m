function [destIm, sulcal] = extractHemispheres1 (dataName)

sulcal = imread(dataName);
sulcal = sulcal(:,:,1);
foo = sulcal;
foo(sulcal < 150) = 0;
n_foo = bwperim(foo);
[L,num] = bwlabel(n_foo);
disp(['Number of Labels is ', num2str(num)]);
%figure, imshow(n_foo);

%cleaning of redundant objects.
c = num;
while c>2
    for j=1:num
        [r, c] = (find(bwlabel(n_foo)==j)); length(r);
        if length(r) <= 800; %Normalde 800 alıyordum.
            n_foo(bwlabel(n_foo)== j) = 0;
        else
            %disp(['length is ', num2str(length(r))]); %objelerin buyuklugu
        end
    end
    [r,c] = bwlabel(n_foo);
end
%figure, imshow(n_foo);
destIm = n_foo;
end
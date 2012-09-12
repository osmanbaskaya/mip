function I_extracted = extractHemispheres(I, min_size, option)

I(I <= 1) = 0; % nii'de 1 csf. tum csf pixelleri 0'a esitle.

%ExtractHemispheres2'de 8 yoktu. Problem cikarsa 8'i sil. atcalc1'de cikabilir
I_perim = bwperim(I, 8); 
[~, num] = bwlabel(I_perim);

if(strcmp(option, 'verbose'))
    fprintf('\n\t\t- Number of label is %d\n', num);
end

%cleaning of redundant objects (the objects wh are smaller than min_size)
[h, w] = size(I_perim);
I_extracted = zeros(h,w);
wholeObj = bwlabel(I_perim);
for j=1:num
    currObj = (wholeObj == j);
    k = find(currObj == 1);
    L = length(k);
    %sum(sum(currObj));
    if L <= min_size; %atrophycalc icin 20, digeri icin 800 idi.
    else
        I_extracted(k) = 1;
    end
end
end

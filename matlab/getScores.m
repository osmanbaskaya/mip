function hashmap = getScores(dataset)

% Bu fonksiyon dosya icinde bulunan tum sulcal gecen goruntulerden
% bir hashmap kurar. hashmap: isim->expert's_scores

my_str = dir(['*','sulcal','*']);
hashmap = java.util.HashMap;

%% Expert's Scores

kontrol = [4, 1, 5, 4, 7, 1, 2, 4, 8, 0, 0, 7, 5, 5, 6, 3, ...
                        1, 1, 2, 0, 6, 6, 4, 5, 2, 6, 7, 5, 5];
unutkanlik = [4, 5, 5, 4, 6, 6, 6, 7, 4, 5, 6, 1, 8, 6, 6, 5, 6, 5, 5, 7];

ref = [3,1,7,4,2,6,5,8];

yue = [1,2,3,4,5,6,7,8];

miccai12= [7, 4, 3, 2, 1, 8, 5] ;
%% Choosing to the current dataset

if strmatch(dataset, 'kontrol1')
   current_dataset = kontrol;
elseif strmatch(dataset, 'unutkanlik1')
    current_dataset = unutkanlik;
elseif strmatch(dataset, 'yue1')
    current_dataset = yue;
elseif strmatch(dataset, 'ref1')
    current_dataset = ref;
elseif strmatch(dataset, 'miccai12')
    current_dataset = miccai12;
else
    return %TODO Burası problemli
end


%% Building the hashmap 

for k=1:length(my_str)
    dataName = my_str(k).name;
    hashmap.put(dataName, current_dataset(k));
end


end